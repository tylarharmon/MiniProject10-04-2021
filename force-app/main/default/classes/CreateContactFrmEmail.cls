global class CreateContactFrmEmail implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                    Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String subToCompare = 'Create Contact';
        List<Attachment> attachmentList = new List<Attachment>();
        if(email.subject.equalsIgnoreCase(subToCompare)) {
            Contact c = new Contact();
            //c.LastName = email.plainTextBody;
            String[] bodySplit = email.PlainTextBody.split('\n');
            System.debug(bodySplit + ':bodySplit');
            String Name = bodySplit[0].substringAfter(': ');
            System.debug(Name + ' firstName');
            c.LastName  = Name;
            c.Title = bodySplit[1].substringAfter(': ');
            c.Email = bodySplit[2].substringAfter(': ');
            c.Phone = bodySplit[3].substringAfter(': ');
            c.MobilePhone = bodySplit[4].substringAfter(': ');
            c.Department = bodySplit[5].substringAfter(': ');
            c.AccountId = bodySplit[6].substringAfter(': ');
            
            insert c;
             
            // Save attachments, if any
            if(email.textAttachments!=null) {
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = c.Id;
                    attachmentList.add(attachment);
                }
            }
 
            //Save any Binary Attachment
            if(email.binaryAttachments!=null){
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = c.Id;
                    attachmentList.add(attachment);
                }
            }
 
            if(!attachmentList.isEmpty()){
                insert attachmentList;
            }
        }
        result.success = true;
        return result;
    }
}