#!/bin/bash
versao="1.2.0"
clear
echo ""
echo "Bem vindo ao DIP Business"
echo "" 
echo "" 
echo " 		####	  ######   ####"
echo "		#    #      ##     #   #"
echo "		#     #     ##     #    #"
echo "		#      #    ##     #   #"
echo "		#     #     ##     ####"
echo "		#    #      ##     #"
echo "		####      ######   #"
echo "" 
echo "======================================================="
echo "Patch DIP Business"
echo "http://www.digiserve.com.br / 054 3289-5000"
echo "======================================================="
echo ""
echo "Contribuição da Comunidade, em especial o colega Rafael Tavares"
echo ""
sleep 15
echo ""
echo "INICIANDO O PROCESSO..."
echo ""
echo "Instalando ferramentas úteis..."
echo ""
yum install wget mtr dos2unix vim mlocate nmap tcpdump mc nano lynx rsync minicom screen htop subversion deltarpm issabel-callcenter -y
updatedb
echo ""
yum -y dos2unix
echo "Atualizando o sistema..."
echo ""
yum -y update && yum -y upgrade
echo ""
echo "Instalando patch de idiomas, cdr e bilhetagem..."
echo ""
svn co https://github.com/ibinetwork/IssabelBR/trunk/ /usr/src/IssabelBR
cp /var/www/html/modules/billing_report/index.php /var/www/html/modules/billing_report/index.php.bkp
#cp /var/www/html/modules/cdrreport/index.php /var/www/html/modules/cdrreport/index.php.bkp
cp /var/www/html/modules/monitoring/index.php /var/www/html/modules/monitoring/index.php.bkp
cp /var/www/html/modules/campaign_monitoring/index.php /var/www/html/modules/campaign_monitoring/index.php.bkp
rsync --progress -r /usr/src/IssabelBR/web/ /var/www/html/
#amportal restart
echo ""
echo "Instalando audio em Português Brasil"
echo ""
rsync --progress -r -u /usr/src/IssabelBR/audio/ /var/lib/asterisk/sounds/
sed -i '/language=pt_BR/d' /etc/asterisk/sip_general_custom.conf
echo "language=pt_BR" >> /etc/asterisk/sip_general_custom.conf
sed -i '/language=pt_BR/d' /etc/asterisk/iax_general_custom.conf
echo "language=pt_BR" >> /etc/asterisk/iax_general_custom.conf
sed -i '/defaultlanguage=pt_BR/d' /etc/asterisk/asterisk.conf
echo "defaultlanguage=pt_BR" >> /etc/asterisk/asterisk.conf
echo ""
#echo "Instalando codec g729"
#echo ""
echo "Instalando tratamento Hangup Cause"
echo ""
sed -i '/extensions_tratamento_hangupcause.conf/d' /etc/asterisk/extensions_override_issabel.conf
sed -i '/extensions_tratamento_hangupcause.conf/d' /etc/asterisk/extensions_override_issabel.conf
sed -i '/extensions_tratamento_hangupcause.conf/d' /etc/asterisk/extensions_override_issabelpbx.conf
echo "#include /etc/asterisk/extensions_tratamento_hangupcause.conf" >> /etc/asterisk/extensions_override_issabelpbx.conf
rsync --progress -r /usr/src/IssabelBR/etc/asterisk/ /etc/asterisk/
chown asterisk.asterisk /etc/asterisk/extensions_tratamento_hangupcause.conf
echo ""
chown -R asterisk.asterisk /var/lib/asterisk/agi-bin/*
chown -R asterisk.asterisk /var/lib/asterisk/agi-bin/
#test=`asterisk -V | grep "13"`
#if [[ -z $test ]]; then
# release="11"
#else
# release="13"
#fi
#if [[ "$release" = "13" ]]; then
# cp /usr/src/IssabelBR/codecs/codec_g729-ast130-gcc4-glibc2.2-x86_64-pentium4.so /usr/lib64/asterisk/modules/codec_g729.so
# chmod 755 /usr/lib64/asterisk/modules/codec_g729.so
# asterisk -rx "module load codec_g729"
# rsync --progress -r -u /usr/src/IssabelBR/callcenter13/ /opt/issabel/dialer/
# chown asterisk.asterisk /opt/issabel/dialer/
# echo ""
# echo "Ajustando arquivo features.conf para Asterisk 13"
# echo ""
# cp /var/www/html/admin/modules/parking/functions.inc/dialplan.php /var/www/html/admin/modules/parking/functions.inc/dialplan.php.bkp
# CHECKFILE=$(sed '63!d' /var/www/html/admin/modules/parking/functions.inc/dialplan.php); if [[ "${CHECKFILE}" == *"addFeatureGeneral('parkedplay"* ]]; then sed -i '63d' /var/www/html/admin/modules/parking/functions.inc/dialplan.php; echo "Ajuste efetuado"; else echo "Não é necessário efetuar o ajuste"; fi
# sed -i '/parkedplay=both/d' /etc/asterisk/features_general_additional.conf
# echo ""
# yum install asterisk13-sqlite3.x86_64 -y
# mv -n /etc/asterisk/cdr_sqlite3_custom.conf /etc/asterisk/cdr_sqlite3_custom.conf.bkp
# mv -n /etc/asterisk/cdr_sqlite3_custom_a13.conf /etc/asterisk/cdr_sqlite3_custom.conf
# sed -i '/app_mysql.so/d' /etc/asterisk/modules_custom.conf
# echo "noload => appmysql.so" >> /etc/asterisk/modules_custom.conf
# sed -i '/cdr_mysql.so/d' /etc/asterisk/modules_custom.conf
# echo "noload => cdrmysql.so" >> /etc/asterisk/modules_custom.conf
#else
# cp /usr/src/IssabelBR/codecs/codec_g729-ast110-gcc4-glibc-x86_64-pentium4.so /usr/lib64/asterisk/modules/codec_g729.so
# chmod 755 /usr/lib64/asterisk/modules/codec_g729.so
# asterisk -rx "module load codec_g729"
#fi
echo ""
echo "Instalando sngrep"
echo "" 
rm -Rf /etc/yum.repos.d/irontec.repo
cat > /etc/yum.repos.d/irontec.repo <<EOF
[irontec]
name=Irontec RPMs repository
baseurl=http://packages.irontec.com/centos/\$releasever/\$basearch/
EOF
rpm --import http://packages.irontec.com/public.key
yum install sngrep -y
echo ""
wget https://bintray.com/ookla/rhel/rpm -O /etc/yum.repos.d/bintray-ookla-rhel.repo
yum install speedtest -y
wget -O /usr/bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
chmod +x /usr/bin/speedtest-cli
#echo "REMOVENDO CADASTRO TELA INDEX"
echo ""
sed -i -r 's/666699/33697B/' /var/www/html/modules/pbxadmin/themes/default/css/mainstyle.css
sed -i -r 's/666699/33697B/' /var/www/html/admin/assets/css/mainstyle.css
#sed -i '/neo-modal-issabel-popup-box/d' /var/www/html/themes/tenant/_common/index.tpl
#sed -i '/neo-modal-issabel-popup-title/d' /var/www/html/themes/tenant/_common/index.tpl
#sed -i '/neo-modal-issabel-popup-close/d' /var/www/html/themes/tenant/_common/index.tpl
#sed -i '/neo-modal-issabel-popup-content/d' /var/www/html/themes/tenant/_common/index.tpl
#sed -i '/neo-modal-issabel-popup-blockmask/d' /var/www/html/themes/tenant/_common/index.tpl
echo ""
echo "ALTERANDO MUSICONHOLD AGENTS"
echo ""
sed -i -r 's/;musiconhold=default/musiconhold=none/' /etc/asterisk/agents.conf
rm -Rf /usr/src/IssabelBR
amportal restart
clear
echo "" 
echo " 		####	  ######   ####"
echo "		#    #      ##     #   #"
echo "		#     #     ##     #    #"
echo "		#      #    ##     #   #"
echo "		#     #     ##     ####"
echo "		#    #      ##     #"
echo "		####      ######   #"
echo "" 
echo "======================================================="
echo "" 
echo "            Patch DIP Business Instalado!"
echo "" 
echo "          Maiores detalhes entre em contato!"
echo ""  
echo "      http://www.digiserve.com.br / 054 3289-5000"
echo "" 
echo "======================================================="
echo ""
echo ""
echo ""
echo "** RECOMENDADO REINICIAR O SERVIDOR PARA EXECUTAR NOVO KERNEL E NOVO DAHDI **"
echo ""
