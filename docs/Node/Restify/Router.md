## Module Node.Restify.Router

#### `RouterM`

``` purescript
data RouterM e a
  = RouterM (Router -> Eff e a)
```

Monad responsible for router related operations (initial setup mostly).

##### Instances
``` purescript
Functor (RouterM e)
Apply (RouterM e)
Applicative (RouterM e)
Bind (RouterM e)
Monad (RouterM e)
MonadEff eff (RouterM eff)
```

#### `Router`

``` purescript
type Router e = RouterM (restify :: RESTIFY | e) Unit
```

#### `useRouter`

``` purescript
useRouter :: forall e opts. MethodOpts opts => opts -> Router e -> Server e
```

Apply routes to a server.

#### `useRouter'`

``` purescript
useRouter' :: forall e. Router e -> Server e
```

#### `apply`

``` purescript
apply :: forall e. Router e -> Router -> RestifyM e Unit
```

Apply Router actions to a Restify router.

#### `http`

``` purescript
http :: forall e opts. MethodOpts opts => Method -> opts -> Handler e -> Router e
```

Bind specified handler to handle request matching route and method.

#### `get`

``` purescript
get :: forall e opts. MethodOpts opts => opts -> Handler e -> Router e
```

Shortcut for `http GET`

#### `head`

``` purescript
head :: forall e opts. MethodOpts opts => opts -> Handler e -> Router e
```

Shortcut for `http HEAD`

#### `post`

``` purescript
post :: forall e opts. MethodOpts opts => opts -> Handler e -> Router e
```

Shortcut for `http POST`

#### `put`

``` purescript
put :: forall e opts. MethodOpts opts => opts -> Handler e -> Router e
```

Shortcut for `http PUT`

#### `patch`

``` purescript
patch :: forall e opts. MethodOpts opts => opts -> Handler e -> Router e
```

Shortcut for `http PATCH`

#### `del`

``` purescript
del :: forall e opts. MethodOpts opts => opts -> Handler e -> Router e
```

Shortcut for `http DEL`

#### `opts`

``` purescript
opts :: forall e opts. MethodOpts opts => opts -> Handler e -> Router e
```

Shortcut for `http OPTS`


