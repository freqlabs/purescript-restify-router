module Hello.Api
       ( router
       ) where

import Node.Restify.Handler (Handler())
import Node.Restify.Response (json)
import Node.Restify.Router (Router(), get)


router :: forall e. Router e
router = do
  get "/foo" getFoo

getFoo :: forall e. Handler e
getFoo = json { msg: "Hello", who: "World" }
