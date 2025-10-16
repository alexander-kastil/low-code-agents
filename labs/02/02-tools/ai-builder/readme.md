# Microsoft Copilot Studio - Lab 05: Invoke AI Builder prompts

## Prerequisites

Labs have been designed to be completed with only a Microsoft Copilot Studio trial. You can start most labs without having to complete the previous module but note that some exercises may reference previous labs. To fully experience the features and functionality of the product, it is recommended that you make sure to have completed all pre-requisites below before starting this lab.

For this lab you need:

A computer with internet access.

Be able to log into the provided Microsoft tenant (some companies enforce users to only connect to their company tenant) or your own enterprise tenant with a Copilot Studio User License (or trial)

Generative AI should be set to “classic” (in Settings, Generative AI)

Complete Lab 04

Access to an active ServiceNow instance (URL, login and password) – don’t forget to wake the instance if you use a trial

Authentication must be set to “Authenticate with Microsoft” (in Settings, Security, Authentication)

## AI Builder prompts

Think of a prompt as a task or a goal you give to the large language model (LLM). With prompt builder, you can build, test, and save your custom prompts. You can also use input variables to provide dynamic context data at runtime. You can share these prompts with others and use them in Power Automate, Power Apps, or Copilot Studio. For instance, you could make a prompt to pick out action items from your company emails and use it in a Power Automate flow to build an email processing automation.

Prompt builder enables makers to devise custom prompts that cater to their specific business needs using natural language. These prompts can be employed for many tasks or business scenarios, such as summarizing content, categorizing data, extracting entities, translating languages, assessing sentiment, or formulating a response to a complaint.

Prompts can be integrated into flows to build intelligent hands-off automation. Makers can also build advanced generative AI capabilities for their applications by describing them as natural language prompts. These prompts can be used to extend a custom copilot, thereby streamlining your daily business operations and boosting efficiency."

Custom prompts give makers the freedom to instruct the GPT model to behave in a certain way or to perform a specific task. By carefully crafting a prompt, you can generate responses that suit your specific business needs. This transforms the GPT model into a flexible tool to accomplish various tasks.

### Task 1: Create a prompt to summarize text

Go to Topics, and open Check Ticket Status.

After the last message that contained an Adaptive Card, add another node with the (+) button.
Choose Call an action and select Create a prompt.

![Image](_images/image_2.png)

Give it a name

Ticket customer communication

Add an Input, called

Ticket Details

In the Prompt, paste the below instructions

Under the ## Ticket details section, use the Insert button to select the Details input.

Under Settings, choose Model GPT4o

Test your prompt by pasting the ServiceNow Sample JSON Payload below in the input sample data and selecting Test prompt.

![Image](_images/image_3.png)

Select Save custom prompt

The prompt should be directly added to your topic once you save it. If this is not the case need to click on the (+) icon, Call an action and select your newly created prompt.

![Image](_images/image_4.png)

Select the SNTicketInfo variable for the Details input.

Create a variable for the generated output:

PersonalizedMessage

![Image](_images/image_5.png)

Add a Message node and insert the PersonalizedMessage.text variable.

![Image](_images/image_6.png)

Save

Test

![Image](_images/image_7.png)

## Summary

Thank you for completing the lab ‘Use generative AI orchestration to interact with your connectors. You have successfully:

Created a custom prompt from Copilot Studio

Passed inputs and used output as a generated answer for the end-user

## Terms of Use

By using this document, in whole or in part, you agree to the following terms:

### Notice

Information and views expressed in this document, including (without limitation) URL and other Internet Web site references, may change without notice. Examples depicted herein, if any, are provided for illustration only and are fictitious. No real association or connection is intended or should be inferred. This document does not provide you with any legal rights to any intellectual property in any Microsoft product.

### Use Limitations

Copying or reproduction, in whole or in part, of this document to any other server or location for further reproduction or redistribution is expressly prohibited. Microsoft provides you with this document for purposes of obtaining your suggestions, comments, input, ideas, or know-how, in any form, ("Feedback") and to provide you with a learning experience. You may use this document only to evaluate its content and provide feedback to Microsoft. You may not use this document for any other purpose. You may not modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell this document or any portion thereof. You may copy and use this document for your internal, reference purposes only.

### Feedback

If you give Microsoft any Feedback about this document or the subject matter herein (including, without limitation, any technology, features, functionality, and/or concepts), you give to Microsoft, without charge, the right to use, share, and freely commercialize Feedback in any way and for any purpose. You also give third parties, without charge, the right to use, or interface with, any Microsoft products or services that include the Feedback. You represent and warrant that you own or otherwise control all rights to such Feedback and that no such Feedback is subject to any third-party rights.
