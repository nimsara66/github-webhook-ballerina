import ballerina/log;
import wso2/choreo.sendsms;
import wso2/choreo.sendemail;
import ballerinax/trigger.github;
import ballerina/http;

configurable github:ListenerConfig config = ?;

configurable string toEmail = ?;
configurable string toMobileNo = ?;

listener http:Listener httpListener = new (8090);
listener github:Listener webhookListener = new (config, httpListener);

service github:IssuesService on webhookListener {

    remote function onOpened(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onClosed(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onReopened(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onAssigned(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onUnassigned(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onLabeled(github:IssuesEvent payload) returns error? {
        //Not Implemented
        github:Label? label = payload.label;
        if label is github:Label && label.name == "bug" {
            sendemail:Client sendemailEp = check new ();
            sendsms:Client sendsmsEp = check new ();
            string subject = "Bug reported: " + payload.issue.title;
            var messageBody = "A bug has been reported. Please check " + payload.issue.html_url;
            string sendEmailResponse = check sendemailEp->sendEmail(recipient = toEmail, subject = subject, body = messageBody);
            string sendSmsResponse = check sendsmsEp->sendSms(toMobile = toMobileNo, message = subject);
            log:printInfo("Email sent:" + sendEmailResponse);
            log:printInfo("SMS sent:" + sendSmsResponse);
        } else {

        }
    }
    remote function onUnlabeled(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
}

service /ignore on httpListener {
}

