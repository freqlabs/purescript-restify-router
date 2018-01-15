module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

import Node.Restify.Router (useRouter, useRouter')
import Node.Restify.Server (Server(), listenHttp')
import Node.Restify.Types (RESTIFY)

import Hello.Web as Web
import Hello.Api as Api

server :: forall e. Server e
server = do
  useRouter' Web.router
  useRouter "/api" Api.router

main :: forall e. Eff (console :: CONSOLE, restify :: RESTIFY | e) Unit
main = do
  log "Hello sailor!"
  listenHttp' 8080 server
