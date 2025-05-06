#!/bin/bash

echo "Inicializando ReplicaSet Config Servers..."
docker exec -i mongocfg1 mongosh --eval '
rs.initiate({
    _id: "mongors1conf",
    configsvr: true,
    members: [
        { _id: 0, host: "mongocfg1" },
        { _id: 1, host: "mongocfg2" },
        { _id: 2, host: "mongocfg3" }
    ]
})
'

sleep 5

echo "Inicializando ReplicaSet Shard 1..."
docker exec -i mongors1n1 mongosh --eval '
rs.initiate({
    _id: "mongors1",
    members: [
        { _id: 0, host: "mongors1n1" },
        { _id: 1, host: "mongors1n2" },
        { _id: 2, host: "mongors1n3" }
    ]
})
'

sleep 5

echo "Inicializando ReplicaSet Shard 2..."
docker exec -i mongors2n1 mongosh --eval '
rs.initiate({
    _id: "mongors2",
    members: [
        { _id: 0, host: "mongors2n1" },
        { _id: 1, host: "mongors2n2" },
        { _id: 2, host: "mongors2n3" }
    ]
})
'

sleep 5

echo "Inicializando ReplicaSet Shard 3..."
docker exec -i mongors3n1 mongosh --eval '
rs.initiate({
    _id: "mongors3",
    members: [
        { _id: 0, host: "mongors3n1" },
        { _id: 1, host: "mongors3n2" },
        { _id: 2, host: "mongors3n3" }
    ]
})
'

sleep 5

echo "Agregando Shards al Cluster..."
docker exec -i mongos1 mongosh --eval '
sh.addShard("mongors1/mongors1n1:27017")
sh.addShard("mongors2/mongors2n1:27017")
sh.addShard("mongors3/mongors3n1:27017")
sh.enableSharding("socialTravelDB")
sh.shardCollection("socialTravelDB.posts", { user_id: "hashed" })
'

echo "Inicialización completa"
