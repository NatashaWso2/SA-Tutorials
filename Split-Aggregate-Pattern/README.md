# Split-Aggregate Pattern

Split-Aggregate is a commonly used Enterprise Integration pattern (EIP). One way to achieve this using WSO2 EI is to use the iterate and aggregate mediator.

The iterate mediator will be used to split the JSON array sent by the client and to send each element of the array to a mock API (backend). This mock API will use a filter mediator to filter the employees based on their age (If the age > 18, then the employee will be accepted else rejected). All the responses from the backend will be combined using the aggregate mediator into a single response and will be sent back to the client. 

![img](https://github.com/NatashaWso2/SA-Tutorials/blob/master/Split-Aggregate-Pattern/Resources/Split-Aggregate-Pattern.png)


## Curl command to invoke the API

curl -X POST -H "Content-Type: application/json" -d '[{"Name": "Alex", "Age": 20}, {"Name": "Linda", "Age": 25}, {"Name": "Bob", "Age": 16}]' http://localhost:8280/services/SplitAggregate
