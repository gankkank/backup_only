# Register the api? when start

I would like the computer give its info (ip and something else) when started.

* such as use nodejs without postfix:

time ./serverStart.js

```javascript
#!/usr/bin/env /opt/node/bin/node
(function() {
  var config, content, mail, os, sendEmail;

  mail = require("nodemailer");

  os = require("os");

  sendEmail = function(text, conf) {
    var mailOptions, smtpTransport, textContent;
    textContent = "  <pre>  " + (JSON.stringify(text.net, null, 4)) + "  </pre>  <pre>  " + (JSON.stringify(text.cpus, null, 4)) + "  </pre>";
    smtpTransport = mail.createTransport("SMTP", {
      service: "Gmail",
      auth: {
        user: conf.auth.user,
        pass: conf.auth.pass
      }
    });
    mailOptions = {
      from: conf.from,
      to: conf.to,
      subject: conf.subject,
      html: textContent
    };
    return smtpTransport.sendMail(mailOptions, function(err, response) {
      if (err) {
        return console.log(err);
      } else {
        console.log("Message sent: " + response.message);
        return smtpTransport.close();
      }
    });
  };

  config = {
    auth: {}
  };

  config.subject = "Server Start [" + (os.hostname()) + "]";

  config.auth = {
    user: "jimmy.gravitas@gmail.com",
    pass: "xxxxxxxxx"
  };

  config.from = "server notice<jimmy.gravitas@gmail.com>";

  config.to = "jimmy.yang@gravitas.com.hk";

  content = {
    net: os.networkInterfaces(),
    cpus: os.cpus()
  };

  sendEmail(content, config);

}).call(this);

```

* such python, but almost the same speed:

```python
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email import Encoders
import os

gmail_user = "jimmy.gravitas@gmail.com"
gmail_pwd = "zzzzzzzz"

def mail(to, subject, text):
   msg = MIMEMultipart()

   msg['From'] = gmail_user
   msg['To'] = to
   msg['Subject'] = subject

   msg.attach(MIMEText(text))
   mailServer = smtplib.SMTP("smtp.gmail.com", 587)
   mailServer.ehlo()
   mailServer.starttls()
   mailServer.ehlo()
   mailServer.login(gmail_user, gmail_pwd)
   mailServer.sendmail(gmail_user, to, msg.as_string())
   # Should be mailServer.quit(), but that crashes...
   mailServer.close()

mail("jimmy.yang@gravitas.com.hk",
   "Hello from python!",
   "This is a email sent with python")

```
