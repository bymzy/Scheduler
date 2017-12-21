#! /usr/bin/python
# -*- coding: utf-8 -*-
import smtplib
import sys

from email.MIMEText import MIMEText  
from email.Utils import formatdate  
from email.Header import Header 

#邮件标题和内容  

argc = len(sys.argv)

if argc != 3:
    print 'Not Enough Args From Send Email, Exit !'
    sys.exit(2)

subject  = sys.argv[1]
body     = sys.argv[2]

smtpHost = 'smtp.126.com'  
sslPort  = '465'  
fromMail = 'xxxx@126.com'  
toMail   = 'xxxx@126.com'  
username = 'xxxx@126.com'  
password = 'xxxxx'
    

#初始化邮件
encoding = 'utf-8'  
mail = MIMEText(body,'plain',encoding)  
mail['Subject'] = Header(subject,encoding)  
mail['From'] = fromMail  
mail['To'] = toMail  
mail['Date'] = formatdate()

smtp = smtplib.SMTP_SSL(smtpHost,sslPort)  
smtp.ehlo()  
smtp.login(username,password) 

smtp.sendmail(fromMail,toMail,mail.as_string())  
smtp.close() 


