# Message Transformation

This sample will transform the message using the Data Mapper and Payload Factory mediator.

![img](https://github.com/NatashaWso2/SA-Tutorials/blob/master/Message-Transformation/Resources/Message-transformation.png)

The client would pass the following XML payload with the firstname, middlename and lastname of each employee separately.

```xml
<Employees>
   <Employee>
      <FirsName>Albus</FirsName>
      <MiddleName>Severus</MiddleName>
      <LastName>Potter</LastName>
   </Employee>
   <Employee>
      <FirsName>Lily</FirsName>
      <MiddleName>Evans</MiddleName>
      <LastName>Potter</LastName>
   </Employee>
</Employees>
```

Using the Data Mapper the firstname, middlename and lastname of each employee will be concatenated together to get the full name. The result of this would be a XML payload with the fullnames of the employees.

```xml
<Employees>
   <Employee>
        <fullName>Albus Severus Potter</fullName>
   </Employee>
   <Employee>
        <fullName>Lily Evans Potter</fullName>
   </Employee>
</Employees>
```

Using the payload factory mediator the resulting XML will be converted to a JSON and will be responded back to the client.

```json
{"Employees": [
    { "fullName" : "Albus Severus Potter" },
    { "fullName" : "Lily Evans Potter" }
]}

````
## Curl command to invoke the API

Save the following request to a file called "request.xml".
```xml
<Employees>
   <Employee>
      <FirsName>Albus</FirsName>
      <MiddleName>Severus</MiddleName>
      <LastName>Potter</LastName>
   </Employee>
   <Employee>
      <FirsName>Lily</FirsName>
      <MiddleName>Evans</MiddleName>
      <LastName>Potter</LastName>
   </Employee>
</Employees>
```
curl -X POST -H "Content-Type: text/xml" -d @request.xml  https://localhost:9443/services/MessageTransformation
