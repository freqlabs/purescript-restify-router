module Hello.Web
       ( router
       ) where

import Prelude

import Data.Maybe (Maybe(..))

import Node.Restify.Handler (Handler())
import Node.Restify.Request (getRouteParam)
import Node.Restify.Response (send)
import Node.Restify.Router (Router(), get, head)


router :: forall e. Router e
router = do
  get  "/" indexHandler
  head "/" indexHandler
  get  "/hello/:name" helloHandler

indexHandler :: forall e. Handler e
indexHandler = send "Hello world"

helloHandler :: forall e. Handler e
helloHandler = do
  param <- getRouteParam "name"
  case param of
    Nothing -> send "oops"
    Just name -> send $ "Hello, " <> name
