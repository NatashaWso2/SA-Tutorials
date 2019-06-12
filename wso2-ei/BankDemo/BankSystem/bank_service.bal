import ballerina/http;
import ballerina/log;
import ballerina/mysql;
import ballerina/sql;

mysql:Client bankDB = new({
        host: "localhost",
        port: 3306,
        name: "bankdb",
        username: "root",
        password: "root123456789",
        dbOptions: { useSSL: false }
});

@http:ServiceConfig {
    basePath: "/bank"
}
service echo on new http:Listener(9090) {

    // Retreive all accounts 
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/accounts"
    }
    resource function retreiveAllAccounts(http:Caller caller, http:Request req) {
        http:Response res = new;
        var selectRet = bankDB->select("SELECT * FROM accounts", ());
        if (selectRet is table<record {}>) {
            var jsonRet = json.convert(selectRet);
            if (jsonRet is json) {
                res.statusCode = 200;
                res.setJsonPayload(untaint jsonRet);
            } else {
                res.statusCode = 500;
                json responseJson = { "error": "Error when converting the retreived records to json conversion" };
                res.setJsonPayload(untaint responseJson);
            }
        } else {
            res.statusCode = 500;
            json responseJson = { "error": "Unable to retreive all accounts from account table failed: " + <string>selectRet.detail().message };
            res.setJsonPayload(untaint responseJson);
        }
        
        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", err = result);
        }
    }

    // Retreive information of a particular acccount by id
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/accounts/{accountId}"
    }
    resource function retreiveAccountById(http:Caller caller, http:Request req, int accountId) {
        http:Response res = new;
        var selectByIdRet = bankDB->select("SELECT * FROM accounts where accountId = ?", (), accountId);
        if (selectByIdRet is table<record {}>) {
            var jsonRet = json.convert(selectByIdRet);
            if (jsonRet is json) {
                if (jsonRet.length() > 0) {
                    res.statusCode = 200;
                    res.setJsonPayload(untaint jsonRet[0]);
                } else {
                    res.statusCode = 404;
                    json responseJson = { "error": "No account associated with id " + accountId };
                    res.setJsonPayload(untaint responseJson);
                }
            } else {
                res.statusCode = 500;
                json responseJson = { "error": "Error when converting the retreived records to json conversion" };
                res.setJsonPayload(untaint responseJson);
            }
        } else {
            res.statusCode = 500;
            json responseJson = { "error": "Unable to retreive account information from account table failed: " + <string>selectByIdRet.detail().message };
            res.setJsonPayload(untaint responseJson);
        }
        
        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", err = result);
        }
    }

    // Update multiple accounts
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/accounts/"
    }
    resource function updateAccounts(http:Caller caller, http:Request req) {
        var accountArr = req.getJsonPayload();
        http:Response res = new;
        if (accountArr is json) {
            if (accountArr.Entries != null) {
                json entityArr = accountArr.Entries.Entry;
                int length = entityArr.length();
                int i = 0;
                if (entityArr is json[]) {
                    while (i < length) {
                        int accountId = <int>entityArr[i].accountId;
                        decimal accountBalance = <decimal>entityArr[i].balance;
                        var updateRet = bankDB->update("UPDATE accounts SET balance = ? WHERE accountId = ?", accountBalance, accountId);
                        handleUpdate(updateRet, "Failed to update the account with Id " + accountId);
                        i = i + 1;
                    }
                } else {
                    int accountId = <int>entityArr.accountId;
                    decimal accountBalance = <decimal>entityArr.balance;
                    var updateRet = bankDB->update("UPDATE accounts SET balance = ? WHERE accountId = ?", accountBalance, accountId);
                    handleUpdate(updateRet, "Failed to update the account with Id " + accountId);
                }
                res.statusCode = 200;
                json responseJson = { "message": "Accounts updated successfully" };
                res.setJsonPayload(untaint responseJson);
            } else {
                res.statusCode = 200;
            }
        } else {
            res.statusCode = 500;
            json responseJson = { "error": <string>accountArr.detail().message };
            res.setJsonPayload(untaint responseJson);
        }

        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", err = result);
        }
    }

    // Withdraw money and update the account balance
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/withdraw/"
    }
    resource function perfromWithdrawl(http:Caller caller, http:Request req) {
        var accountArr = req.getJsonPayload();
        http:Response res = new;
        if (accountArr is json) {
            // Check if account id exsits in the account table
            int accountId = <int>accountArr["transaction"].id;
            var selectByIdRet = bankDB->select("SELECT * FROM accounts WHERE accountId = ?", (), accountId);
            if (selectByIdRet is table<record {}>) {
                var jsonRet = json.convert(selectByIdRet);
                if (jsonRet is json) {
                    // Check if JSON array is empty. This means that the account id is invalid
                    if (jsonRet.length() == 1) {
                        decimal withdrawlAmount = <decimal>accountArr["transaction"].amount;
                        decimal availableBalance = <decimal> jsonRet[0].balance;
                        // Check if the available balance > amount to be withdrawed. There should be atleast 100 in the account balance.
                        if (availableBalance > withdrawlAmount && (availableBalance - withdrawlAmount > 100)) {
                            // Calculate the new balance
                            decimal newBalance = availableBalance - withdrawlAmount;
                            // Update the new balance
                            var updateRet = bankDB->update("UPDATE accounts SET balance = ? WHERE accountId = ?", newBalance, accountId);
                            res.statusCode = 200;
                            json responseJson = {"success" : "Transaction was completed successfully", 
                                                 "message": "An amount of $" + withdrawlAmount + " was withdrawn from account with id " + accountId + ". "
                                            + "Available balance is $" + newBalance };
                            res.setJsonPayload(untaint responseJson); 
                        } else {
                            res.statusCode = 200;
                            json responseJson = { "error": "Cannot withdraw from account with id " + accountId + " since the balance is less than the amount to be withdrawn",
                                                  "available balance" : "$" + availableBalance};
                            res.setJsonPayload(untaint responseJson); 
                        }
                    } else {
                        res.statusCode = 500;
                        json responseJson = { "error": "No account associated with id " + accountId };
                        res.setJsonPayload(untaint responseJson); 
                    }
                } else {
                    res.statusCode = 500;
                    json responseJson = { "error": "Error when converting the retreived records to json conversion" };
                    res.setJsonPayload(untaint responseJson);
                }
            } else {
                res.statusCode = 500;
                json responseJson = { "message": "Unable to retreive account information from account table failed: " + <string>selectByIdRet.detail().message };
                res.setJsonPayload(untaint responseJson);
            }
        } else {
            res.statusCode = 500;
            json responseJson = { "message": <string>accountArr.detail().message };
            res.setJsonPayload(untaint responseJson);
        }

        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", err = result);
        }
    }
}

// The main function will act as a triggering point to notify that the backend is up and running. This will update the bank system with the actual balances in the transaction db.
public function main() {
    http:Client clientEP = new("http://localhost:8280");
    var resp = clientEP->get("/resync/accounts");
    if (resp is http:Response) {
        var payload = resp.getJsonPayload();
        if (payload is json) {
            http:Client bankEP = new("http://0.0.0.0:9090");
            http:Request req = new;
            req.setJsonPayload(untaint payload);
            var postResp = bankEP->post("/bank/accounts", req);
        } else {
            log:printError(<string> payload.detail().message);
        }
    } else {
        log:printError(<string> resp.detail().message);
    }
}

// Hanlde update operations
function handleUpdate(sql:UpdateResult|error returned, string message) {
    if (returned is sql:UpdateResult) {
        log:printInfo("Successfully updated the account");
    } else {
        log:printError(message + " failed: " + <string>returned.detail().message);
    }
}