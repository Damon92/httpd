From centos:7.4.1708
MAINTAINER Damon.Dai daikaiguo@rayvision.com
RUN yum -y install epel-release
RUN (yum install sendmail.x86_64 git python-requests crontabs wget fping httpd gcc make python-pip python-rrdtool rrdtool perl-rrdtool openssl openssl-devel -y ;\
     yum install perl-Sys-Syslog perl-Module-CoreList perl-ExtUtils-Manifest \
                 perl-Digest-MD5 perl-IPC-Cmd -y ;\
     yum install perl-CPAN perl-Sys-Syslog perl-Module-CoreList perl-CGI \
                 perl-Digest-MD5 perl-Digest-HMAC perl-Test-NoWarnings \
                 perl-Test-Deep perl-Test-Warn perl-CPAN-Meta perl-Module-Build \
                 perl-Test-RequiresInternet perl-URI lrzsz -y)
#RUN wget https://oss.oetiker.ch/smokeping/pub/smokeping-2.6.11.tar.gz
RUN wget https://oss.oetiker.ch/smokeping/pub/smokeping-2.7.1.tar.gz
RUN tar -zxvf smokeping-2.7.1.tar.gz
RUN cd smokeping-2.7.1 && ./configure --prefix=/usr/local/smokeping && make && make install
RUN cd /usr/local/smokeping && mkdir -p data cache var && mkdir etc/location
RUN cp /usr/local/smokeping/htdocs/smokeping.fcgi.dist /usr/local/smokeping/htdocs/smokeping.fcgi
RUN chown apache:apache -R /usr/local/smokeping
RUN chmod -R 755 /usr/local/smokeping
RUN chmod 600 /usr/local/smokeping/etc/smokeping_secrets.dist
RUN cd /usr/local/smokeping/etc/ && cp basepage.html.dist  basepage.html && cp config.dist config
RUN cd /usr/local/smokeping/etc/ && sed -i 's/\/path\/to/\/usr\/local\/smokeping\/etc/g' config
RUN cd /root/ && git clone https://github.com/Damon92/httpd.git && bash httpd/http.conf
RUN cp /root/httpd/smokeping /etc/init.d/
RUN cp -rf /root/httpd/basepage.html.dist /usr/local/smokeping/etc/
RUN cp -rf /root/httpd/location/* /usr/local/smokeping/etc/location
RUN cp -rf /root/httpd/config /usr/local/smokeping/etc/
RUN cd /usr/local/smokeping/ && ln -s htdocs/smokeping.fcgi smokeping.fcgi
RUN chmod 755 /etc/init.d/smokeping
RUN mv /etc/localtime /etc/localtime.bak
RUN cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
