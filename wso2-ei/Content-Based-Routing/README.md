# Content Based Routing

This sample will route a message based on its content.

![img](https://github.com/NatashaWso2/SA-Tutorials/blob/master/Content-Based-Routing/Resources/Content-based-routing.png)

This will route the cities "London" and "SanFransisco" to a mocky backend and will respond back with their respective station, longitude and latitude. If you provide a city other than "London" and "SanFransisco" it will return an invalid city station response.

## Curl command to invoke the API

curl -X POST -H "Content-Type: application/json" -d '{"city" : "London"}' http://localhost:8280/context/route

curl -X POST -H "Content-Type: application/json" -d '{"city" : "SanFransisco"}' http://localhost:8280/context/route
