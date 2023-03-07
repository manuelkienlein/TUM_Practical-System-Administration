import csv
import os

# read the users.csv file containing our list of users to be added:
with open('users.csv', mode ='r') as file:
        csvFile = csv.DictReader(file)

        # create .ldif file and choose mode w so it can be overwritten:
        f = open("add_new_users2.ldif", "w")

        # create a counter for our uids
        counter = 8000

        # loop over all lines in users.csv and write to our .ldif file:
        for lines in csvFile:
                f.write("dn: uid=" + lines["Matrikelnummer"] + ",ou=users,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" + "\n")
                f.write("objectClass: posixAccount" + "\n")
                f.write("objectClass: inetOrgPerson" + "\n")
                f.write("objectClass: organizationalPerson" + "\n")
                f.write("objectClass: person" + "\n")
                f.write("objectClass: extensibleObject" + "\n")
                f.write("objectClass: x-menschen" + "\n")
                f.write("homeDirectory: /home/" + lines["Matrikelnummer"] + "\n")
                f.write("loginShell: /bin/bash" + "\n")
                f.write("uid: " + lines["Matrikelnummer"] + "\n")
                f.write("cn: " + lines["Name"] + " " + lines["Vorname"] + "\n")
                f.write("uidNumber: " + str(counter) + "\n")
                f.write("gidNumber: 100" + "\n")
                f.write("sn: " + lines["Name"] + "\n")
                f.write("givenName: " + lines["Vorname"] + "\n")
                f.write("street: " + lines["Strasse"] + "\n")
                f.write("postalCode: " + lines["PLZ"] + "\n")
                f.write("l: " + lines["Ort"] + "\n")
                # not all entries have nationalities given in proper format (2 digits)
                if len(lines["Nationalitaet"]) == 2:
                        f.write("c: " + lines["Nationalitaet"] + "\n")
                f.write("telephoneNumber: " + lines["Telefon"] + "\n")
                f.write("x-gender: " + lines["Geschlecht"] + "\n")
                f.write("x-dateOfBirth: " + lines["Geburtsdatum"] + "\n")
                f.write("x-placeOfBirth: " + lines["Geburtsort"] + "\n")

                # generate private key
                print('openssl genrsa -out ' + '/var/tmp/keys/privatekey' + str(lines['Matrikelnummer']).replace(">","") + '.pem 2048')
                # derive public key from private key
                os.system('openssl genrsa -out ' + '/var/tmp/keys/privatekey' + str(lines['Matrikelnummer']).replace(">","") + '.pem 2048')
                os.system('openssl rsa -in /var/tmp/keys/privatekey' + str(lines['Matrikelnummer']).replace(">","") + '.pem -out /var/tmp/keys/publickey' + str(lines['Matrikelnummer']).replace(">","") + '.pem -pubout -outform PEM')
                # create certificate
                os.system('certtool --generate-certificate --load-privkey /var/tmp/keys/privatekey' + str(lines['Matrikelnummer']).replace(">","") + '.pem --load-ca-certificate /etc/ssl/certs/ca-team8.pem --load-ca-privkey /etc/ssl/private/ca-team8-private.pem --template /etc/ssl/ldap.info --outfile /var/tmp/certificates/' + str(lines['Matrikelnummer']).replace(">","") + '_cert.pem > /dev/null 2>&1')

                cert = open('/var/tmp/certificates/' + str(lines['Matrikelnummer']).replace(">","") + '_cert.pem', mode = 'r')

                # read in user certificate and write to .ldif
                key_lines = cert.readlines()

                f.write("userCertificate;binary:: " + "".join(key_lines[1:-1]).replace('\n',"\n ") + "\n")
                f.write("\n")

                counter += 1

#               break

        f.close()


# lines[0]: Name # sn
# lines[1]: Vorname # givenName
# lines[2]: Geschlecht
# lines[3]: Geburtsdatum
# lines[4]: Geburtsort
# lines[5]: Nationalität
# lines[6]: Strasse # street
# lines[7]: PLZ # postalCode
# lines[8]: Ort # city
# lines[9]: Telefon # telephoneNumber
# lines[10]: Matrikelnummer # uid