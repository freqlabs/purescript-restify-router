module Node.Restify.Router
       ( RouterM(..), Router()
       , useRouter, useRouter', apply
       , http, get, head, post, put, patch, del, opts
       ) where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (class MonadEff)
import Data.Foreign (Foreign, toForeign)
import Data.Function.Uncurried (Fn2, Fn3, Fn4, runFn2, runFn3, runFn4)

import Node.Restify.Types as R
import Node.Restify.Handler (Handler(), runHandlerM)
import Node.Restify.Server (Server(), ServerM(..))


-- | Monad responsible for router related operations (initial setup mostly).
data RouterM e a = RouterM (R.Router -> Eff e a)
type Router e = RouterM (restify :: R.RESTIFY | e) Unit

type HandlerFn e = R.Request -> R.Response -> Eff (restify :: R.RESTIFY | e) Unit
                -> Eff (restify :: R.RESTIFY | e) Unit

instance functorRouterM :: Functor (RouterM e) where
  map f (RouterM h) = RouterM \router -> liftM1 f $ h router

instance applyRouterM :: Apply (RouterM e) where
  apply (RouterM f) (RouterM h) = RouterM \router -> do
    res <- h router
    trans <- f router
    pure $ trans res

instance applicativeRouterM :: Applicative (RouterM e) where
  pure x = RouterM \_ -> pure x

instance bindRouterM :: Bind (RouterM e) where
  bind (RouterM h) f = RouterM \router -> do
    res <- h router
    case f res of
      RouterM g -> g router

instance monadRouterM :: Monad (RouterM e)

instance monadEffRouterM :: MonadEff eff (RouterM eff) where
  liftEff act = RouterM \_ -> act


-- | Apply routes to a server.
useRouter :: forall e opts. (R.MethodOpts opts) => opts -> Router e -> Server e
useRouter prefix (RouterM act) = ServerM \server -> do
  router <- mkRouter
  act router
  runFn3 applyRoutes router server (toForeign prefix)

useRouter' :: forall e. Router e -> Server e
useRouter' (RouterM act) = ServerM \server -> do
  router <- mkRouter
  act router
  runFn2 applyRoutes1 router server

-- | Apply Router actions to a Restify router.
apply :: forall e. Router e -> R.Router -> R.RestifyM e Unit
apply (RouterM act) router = act router

-- | Bind specified handler to handle request matching route and method.
http :: forall e opts. (R.MethodOpts opts) => R.Method -> opts -> Handler e -> Router e
http method route handler = RouterM \router ->
  runFn4 _http router (show method) (toForeign route) $ runHandlerM handler

-- | Shortcut for `http GET`
get :: forall e opts. (R.MethodOpts opts) => opts -> Handler e -> Router e
get = http R.GET

-- | Shortcut for `http HEAD`
head :: forall e opts. (R.MethodOpts opts) => opts -> Handler e -> Router e
head = http R.HEAD

-- | Shortcut for `http POST`
post :: forall e opts. (R.MethodOpts opts) => opts -> Handler e -> Router e
post = http R.POST

-- | Shortcut for `http PUT`
put :: forall e opts. (R.MethodOpts opts) => opts -> Handler e -> Router e
put = http R.PUT

-- | Shortcut for `http PATCH`
patch :: forall e opts. (R.MethodOpts opts) => opts -> Handler e -> Router e
patch = http R.PATCH

-- | Shortcut for `http DEL`
del :: forall e opts. (R.MethodOpts opts) => opts -> Handler e -> Router e
del = http R.DEL

-- | Shortcut for `http OPTS`
opts :: forall e opts. (R.MethodOpts opts) => opts -> Handler e -> Router e
opts = http R.OPTS


foreign import mkRouter :: forall e. R.RestifyM e R.Router

foreign import applyRoutes ::
  forall e. Fn3 R.Router R.Server Foreign (Eff (restify :: R.RESTIFY | e) Unit)

foreign import applyRoutes1 ::
  forall e. Fn2 R.Router R.Server (Eff (restify :: R.RESTIFY | e) Unit)

foreign import _http ::
  forall e. Fn4 R.Router String Foreign (HandlerFn e) (Eff (restify :: R.RESTIFY | e) Unit)
