# Microsoft Copilot Studio - Lab 06: Make HTTP requests to connect to an API

![Image](./_images/image_1.png)

Lab 06: Make HTTP requests to connect to an API

Hands-on lab step-by-step

November 2024

Microsoft Copilot Studio Workshop

# Microsoft Copilot Studio

This lab is subject to the Terms of Use found at the end of this document.

## Goals for this lab

| After this lab you will be able to:
Understand the basics of the HTTP Request node
Use Copilot Studio to request data from another data source using HTTP node in a basic use case (using the Gemini) and return the data in a conversational dialog with a customer or user | The time to complete this lab is [20] minutes. |
|--|--|

## Prerequisites

Labs have been designed to be completed with only a Microsoft Copilot Studio trial. You can start most labs without having to complete the previous module but note that some exercises may reference previous labs. To fully experience the features and functionality of the product, it is recommended that you make sure to have completed all pre-requisites below before starting this lab.

For this lab you need:

A computer with internet access.

Be able to log into the provided Microsoft tenant (some companies enforce users to only connect to their company tenant) or your own enterprise tenant with a Copilot Studio User License (or trial)

Generative AI should be set to “classic” (in Settings, Generative AI)

Access to external website (https://api.gemini.com)

## Exercise 1: Build a simple HTTP request node query

Connecting to data provides companies with some of the most benefits as it provides information and insight to users that is up to date and often the relevant for customer or user questions.

In this exercise, you will go through creating a new topic, adding a simple HTTP Request node action to retrieve information from an external service, and display that data back to the user.

### Task 1: Create a new topic

Open the Copilot Studio authoring canvas’ Topics page and click Add a topic drop down at the top of the screen, select the From blank option. Name your topic

Crypto Currency Price.

Add some trigger phrases that a user may ask such as the below ones

| | What's the current price of Bitcoin
Can you tell me the latest crypto prices
How much does Bitcoin cost now
What are the prices of digital currencies today
What's the latest on crypto prices | |
|--|--|--|

Create a new Question node and enter this text:

What currency do you want to see the current price of Bitcoin in?

For the purpose of these labs, make the question a Multiple-choice options in Identify.  
Add the Options for user of USD, EUR, and GBP. Save response as a variable named Currency.

Add synonyms for each option, like dollars, euros, and pounds.

![Image](./_image_/image_10.svg)

|     | Pro tip: You can add synonyms by selecting your options and adding synonyms like dollars for USD. |
| --- | ------------------------------------------------------------------------------------------------- |

Copilot Studio will automatically create the choice condition logic underneath the question node.  
We will want to remove all the conditions for this scenario by clicking the ellipsis and then selecting Delete.
![Image](./_image_/image_11.png)

Next, you will want to add the HTTP Request node to make the API call to check the price of Bitcoin. You do this by clicking the (+) and go to Advanced and Send HTTP request.
![Image](./_image_/image_2.png)

Now we need to provide information about the API to allow Copilot Studio to get the price of Bitcoin in the selected Currency. To do this, inside the URL field we will need to select Formula and put the following the Power Fx formula.

|     | Lower(Concatenate("https://api.gemini.com/v2/ticker/btc",Topic.Currency)) |     |
| --- | ------------------------------------------------------------------------- | --- |

This formula does several things. It makes sure that the URL passed in is lower case, then it concatenates the URL to include the currency that the user selected in the question above. This will make sure that the URL for USD or EUR for example is correct for the API.
![Image](./_image_/image_3.svg)

Now we need to provide a sample output of the JSON payload that will be returned by the API to allow the node to parse the response for us.
To do this you select From sample data in the Response data type field in the HTTP Request node.
Select Get schema from sample JSON and paste the below sample JSON payload.

|     | If you struggle copying the below text, go the Misc folder in Lab files, and open Bitcoin Sample JSON Payload.txt |
| --- | ----------------------------------------------------------------------------------------------------------------- |

| | {
"symbol": "BTCUSD",
"open": "67781.09",
"high": "68382.33",
"low": "67293.74",
"close": "67707.13",
"changes": [
"67882.6",
"67781.09",
"67805.66",
"67744.15",
"67651.01",
"67863.46",
"68053.16",
"68080.11",
"68186.09",
"68109.26",
"67914.8",
"68079.54",
"67455.47",
"67468.58",
"67712.98",
"67662.82",
"67771.15",
"67680.26",
"67799.25",
"67736.21",
"67653.87",
"67698.36",
"67832.24",
"67707.13"
],
"bid": "67837.17",
"ask": "67843.41"
} | |
|--|--|--|

Select Confirm.

Then we will create a variable to store the parsed results from the API.  
Name the Variable

CryptoCurrentPrice.

![Image](./_image_/image_4.png)

Now, let’s add a message to give the user of your bot a formatted response to tell them the current price of Bitcoin. Click the (+) to add a new node and select Send a message. You can create your own message leveraging the variables to structure a response to the user about the price of Bitcoin.

|     | The current bid price for Bitcoins in {Topic.Currency} is {Topic.CryptoCurrentPrice.bid} |     |
| --- | ---------------------------------------------------------------------------------------- | --- |

You can use a formula to format the price a specific way, for example with a thousand separators and currency symbols:

| | Switch(
    Text(Topic.Currency),
        "USD",
        Text(Value(Topic.CryptoCurrentPrice.bid),"$#,#.##"),
        "EUR",
        Text(Value(Topic.CryptoCurrentPrice.bid),"#,#.##€"),
        "GBP",
        Text(Value(Topic.CryptoCurrentPrice.bid),"£#,#.##")          
) | |
|--|--|--|

![Image](./_image_/image_5.png)

To end the conversation, select Topic management and Go to another topic and select End of Conversation.

Save your topic

### Task 2: Test your topic

Open the test pane and test your copilot.

|     | What’s the current bid price for Bitcoins in dollars? |     |
| --- | ----------------------------------------------------- | --- |

![Image](./_image_/image_6.png)

You have successfully created a HTTP Request node to provide real time data from an external service to the user!

## Summary

Thank you for completing the lab ‘Make HTTP requests to connect to an API’. You have successfully:

Created a HTTP API call through the HTTP Request node in Copilot Studio

Structured a GET API call using Power Fx

Displayed dynamic data back to the user in Copilot Studio

## Terms of Use

By using this document, in whole or in part, you agree to the following terms:

### Notice

Information and views expressed in this document, including (without limitation) URL and other Internet Web site references, may change without notice. Examples depicted herein, if any, are provided for illustration only and are fictitious. No real association or connection is intended or should be inferred. This document does not provide you with any legal rights to any intellectual property in any Microsoft product.

### Use Limitations

Copying or reproduction, in whole or in part, of this document to any other server or location for further reproduction or redistribution is expressly prohibited. Microsoft provides you with this document for purposes of obtaining your suggestions, comments, input, ideas, or know-how, in any form, ("Feedback") and to provide you with a learning experience. You may use this document only to evaluate its content and provide feedback to Microsoft. You may not use this document for any other purpose. You may not modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell this document or any portion thereof. You may copy and use this document for your internal, reference purposes only.

### Feedback

If you give Microsoft any Feedback about this document or the subject matter herein (including, without limitation, any technology, features, functionality, and/or concepts), you give to Microsoft, without charge, the right to use, share, and freely commercialize Feedback in any way and for any purpose. You also give third parties, without charge, the right to use, or interface with, any Microsoft products or services that include the Feedback. You represent and warrant that you own or otherwise control all rights to such Feedback and that no such Feedback is subject to any third-party rights.

### DISCLAIMERS

CERTAIN SOFTWARE, TECHNOLOGY, PRODUCTS, FEATURES, AND FUNCTIONALITY (COLLECTIVELY "CONCEPTS"),

INCLUDING POTENTIAL NEW CONCEPTS, REFERENCED IN THIS DOCUMENT ARE IN A SIMULATED ENVIRONMENT

WITHOUT COMPLEX SET-UP OR INSTALLATION AND ARE INTENDED FOR FEEDBACK AND TRAINING PURPOSES

ONLY. THE CONCEPTS REPRESENTED IN THIS DOCUMENT MAY NOT REPRESENT FULL FEATURE CONCEPTS AND MAY

NOT WORK THE WAY A FINAL VERSION MAY WORK. MICROSOFT ALSO MAY NOT RELEASE A FINAL VERSION OF SUCH

CONCEPTS. YOUR EXPERIENCE WITH USING SUCH CONCEPTS IN A PHYSICAL ENVIRONMENT MAY ALSO BE DIFFERENT.

THIS DOCUMENT, AND THE CONCEPTS AND TRAINING PROVIDED HEREIN, IS PROVIDED “AS IS”, WITHOUT WARRANTY

OF ANY KIND, WHETHER EXPRESS, IMPLIED, OR STATUTORY, INCLUDING (WITHOUT LIMITATION) THE WARRANTIES OF

MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NONINFRINGEMENT. MICROSOFT DOES NOT

MAKE ANY ASSURANCES OR REPRESENTATIONS WITH REGARD TO THE ACCURACY OF THE RESULTS, THE OUTPUT THAT DERIVES FROM USE OF THIS DOCUMENT OR THE CONCEPTS, OR THE SUITABILITY OF THE CONCEPTS OR INFORMATION CONTAINED IN THIS DOCUMENT FOR ANY PURPOSE.

MICROSOFT COPILOT STUDIO (1) IS NOT INTENDED OR MADE AVAILABLE AS A MEDICAL DEVICE FOR THE

DIAGNOSIS OF DISEASE OR OTHER CONDITIONS, OR IN THE CURE, MITIGATION, TREATMENT OR PREVENTION OF

DISEASE, OR OTHERWISE TO BE USED AS A COMPONENT OF ANY CLINICAL OFFERING OR PRODUCT, AND NO LICENSE

OR RIGHT IS GRANTED TO USE MICROSOFT COPILOT STUDIO FOR SUCH PURPOSES, (2) IS NOT DESIGNED OR

INTENDED TO BE A SUBSTITUTE FOR PROFESSIONAL MEDICAL ADVICE, DIAGNOSIS, TREATMENT, OR JUDGMENT AND SHOULD NOT BE USED AS A SUBSTITUTE FOR, OR TO REPLACE, PROFESSIONAL MEDICAL ADVICE, DIAGNOSIS,

TREATMENT, OR JUDGMENT, AND (3) SHOULD NOT BE USED FOR EMERGENCIES AND DOES NOT SUPPORT EMERGENCY

CALLS. ANY CHATBOT YOU CREATE USING MICROSOFT COPILOT STUDIO IS YOUR OWN PRODUCT OR SERVICE,

SEPARATE AND APART FROM MICROSOFT COPILOT STUDIO. YOU ARE SOLELY RESPONSIBLE FOR THE DESIGN,

DEVELOPMENT, AND IMPLEMENTATION OF YOUR CHATBOT (INCLUDING INCORPORATION OF IT INTO ANY PRODUCT

OR SERVICE INTENDED FOR MEDICAL OR CLINICAL USE) AND FOR EXPLICITLY PROVIDING END USERS WITH

APPROPRIATE WARNINGS AND DISCLAIMERS PERTAINING TO USE OF YOUR CHATBOT. YOU ARE SOLELY RESPONSIBLE

FOR ANY PERSONAL INJURY OR DEATH THAT MAY OCCUR AS A RESULT OF YOUR CHATBOT OR YOUR USE OF

MICROSOFT COPILOT STUDIO IN CONNECTION WITH YOUR CHATBOT, INCLUDING (WITHOUT LIMITATION) ANY SUCH INJURIES TO END USERS.

![Image](./_image_/image_7.png)

![Image](./_image_/image_8.png)

![Image](./_image_/image_9.png)
