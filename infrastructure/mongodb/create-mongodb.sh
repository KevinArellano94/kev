#!/bin/bash

# # # Pull, tag, and push the MongoDB image
# # docker pull mongo:latest
# # docker tag mongo:latest localhost:5000/mongo:latest
# # docker push localhost:5000/mongo:latest

# # echo
# # echo "Applying Kubernetes manifests from ./mongodb/kubernetes/"
# # kubectl apply -f ./kubernetes/
# # kubectl get pods -n kev
# # kubectl get svc -n kev

#  kubectl -n kev exec -it mongo-0 -- mongosh

echo
echo "Waiting for MongoDB pods to be ready..."
kubectl wait --for=condition=ready pod -l app=mongo -n kev --timeout=120s

# use admin
# db.createUser({user: "admin", pwd: "password", roles: [{ role: "root", db: "admin" }]})

echo
echo "Initializing MongoDB replica set..."
# kubectl -n kev exec -it mongo-0 -- mongosh
# kubectl -n kev exec -it mongo-0 -- mongosh --eval '
# rs.initiate(
#   {
#     _id: "rs0",
#     members: [
#       { _id: 0, host: "mongo-0.mongo-service.kev.svc.cluster.local:27017" },
#       { _id: 1, host: "mongo-1.mongo-service.kev.svc.cluster.local:27017" },
#       { _id: 2, host: "mongo-2.mongo-service.kev.svc.cluster.local:27017" }
#     ]
#   }
# )
# ' --quiet

kubectl -n kev exec -it mongo-0 -- mongosh --eval '
rs.reconfig(
  {
    _id: "rs0",
    members: [
      { _id: 0, host: "mongo-0.mongo-service.kev.svc.cluster.local:27017" },
      { _id: 1, host: "mongo-1.mongo-service.kev.svc.cluster.local:27017" },
      { _id: 2, host: "mongo-2.mongo-service.kev.svc.cluster.local:27017" }
    ]
  }
)
' --quiet

# kubectl -n kev exec -it mongo-0 -- mongosh --eval "rs.status()" --quiet

# kubectl -n kev exec -it mongo-0 -- mongosh 'rs.status()'
# kubectl -n kev exec -it mongo-0 -- mongosh 'rs.initiate({_id: "rs0", members: [{ _id: 0, host: "mongo-0.mongo-service.kev.svc.cluster.local:27017" }, { _id: 1, host: "mongo-1.mongo-service.kev.svc.cluster.local:27017" }, { _id: 2, host: "mongo-2.mongo-service.kev.svc.cluster.local:27017" }]})'

# kubectl -n kev exec -it mongo-0 -- mongosh '
# rs.initiate({
#   _id: "rs0",
#   members: [
#     { _id: 0, host: "mongo-0.mongo-service.kev.svc.cluster.local:27017" },
#     { _id: 1, host: "mongo-1.mongo-service.kev.svc.cluster.local:27017" },
#     { _id: 2, host: "mongo-2.mongo-service.kev.svc.cluster.local:27017" }
#   ]
# })
# '

# echo
# echo "Verifying replica set status..."
# kubectl exec -it mongo-0 -n kev -- mongosh -u admin -p password --eval 'rs.status()'

# echo
# echo "Setting up port-forwarding for mongo-service in namespace kev"
# kubectl port-forward svc/mongo-service -n kev 27017:27017 &

# echo
# echo "Port-forwarding is running in the background."
# echo "Press Ctrl+C to stop port-forwarding and exit."
# wait
