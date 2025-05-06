# SocialTravelDB - Proyecto de Replicación y Sharding en MongoDB

## Levantar infraestructura
```
docker-compose up -d
```

## Inicializar ReplicaSets

Entrar en mongocfg1:
```
docker exec -it mongocfg1 mongosh
```

```js
rs.initiate({
    _id: "mongors1conf", 
    configsvr: true, 
    members: [
        { _id: 0, host: "mongocfg1" },
        { _id: 1, host: "mongocfg2" },
        { _id: 2, host: "mongocfg3" }
    ]
})
```

Entrar en mongors1n1:
```
docker exec -it mongors1n1 mongosh
```

```js
rs.initiate({
    _id: "mongors1", 
    members: [
        { _id: 0, host: "mongors1n1" },
        { _id: 1, host: "mongors1n2" },
        { _id: 2, host: "mongors1n3" }
    ]
})
```

Entrar en mongors2n1:
```
docker exec -it mongors2n1 mongosh
```

```js
rs.initiate({
    _id: "mongors2", 
    members: [
        { _id: 0, host: "mongors2n1" },
        { _id: 1, host: "mongors2n2" },
        { _id: 2, host: "mongors2n3" }
    ]
})
```

Entrar en mongors3n1:
```
docker exec -it mongors3n1 mongosh
```

```js
rs.initiate({
    _id: "mongors3", 
    members: [
        { _id: 0, host: "mongors3n1" },
        { _id: 1, host: "mongors3n2" },
        { _id: 2, host: "mongors3n3" }
    ]
})
```
## Agregar Shards y Shardear Colección

Conectarse a mongos1:
```
docker exec -it mongos1 mongosh
```

```js
sh.addShard("mongors1/mongors1n1:27017")
sh.addShard("mongors2/mongors2n1:27017")
sh.addShard("mongors3/mongors3n1:27017")


use socialTravelDB
sh.enableSharding("socialTravelDB")
sh.shardCollection("socialTravelDB.posts", { user_id: "hashed" })
```

## Insertar Datos 

Copiar y ejecutar el script:
```
docker cp populate_social_travel.js mongos1:/populate_social_travel.js
docker exec -it mongos1 mongosh socialTravelDB /populate_social_travel.js
```

## Comprobar que esté todo bien
```
sh.status()
use socialTravelDB
db.postsfindOne()
```