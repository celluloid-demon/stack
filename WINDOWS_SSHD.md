Windows
=======

_**WARNING:** !!Cygwin-based ssh server fails to authenticate if server's ~/.ssh symlinks to outside of cygwin's "drive" !!_

Source: https://gist.github.com/roxlu/5038729

Installing CYGWIN with SSH
  1) Download cygwin setup.exe from http://www.cygwin.com
    - Execute setup.exe
    - Install from internet
    - Root directory: `c:\cygwin` + all users
    - Local package directory: use default value
   - Select a mirror to download files from
   - Select these packages:
     - editors > xemacs 21.4.22-1
     - net > openssh 6.1-p
     - admin > cygrunsrv 1.40-2
   - Click continue
   - When everything is installed configure SSHD

   
  2) Configure SSHD
    - open a cygwin terminal: start > RIGHT MOUSE ON "Cygwin terminal" AND "RUN AS ADMINISTRATOR"
    - $ ssh-host-config
      - Are you sure you want to continue: YES
      - You have the required privileges: YES
      - Overwrite existing /etc/ssh_config: YES
      - Should privilege separation be used: YES
      - Use local account 'sshd': YES
      - Do you want to install 'sshd' as a service: YES
      - name CYGWIN: just press enter
      - Do you want to use a different name: no

     +++ you can skip this ++
      - Create new privileged user account (cyg_server): YES
        - enter password
        - reenter password
     +++ end of skip ++
     
  3) Add a SSHD account
    - Open control panel
    - Create a new account with administrator rights
    - set a password for this new account

  4) Add the user to SSHD password
    $ cd /etc/
    $ cp passwd passwd_bak
    $ /bin/mkpasswd.exe -l -u [new_username] >> /etc/passwd
     (for example: /bin/mkpasswd.exe -l -u roxlu >> /etc/passwd to add the password for roxlu)

  5) Open SSHD port (22)
   - Open control panel
   - Click on System and Security
   - Click on Windows Firewall
   - On the left click on advanced settings
     - click: select "Inbound Rules"
     - click: New Rule ...
              - [x] Port
                NEXT

              - TCP 
                Specific ports: 22
                NEXT

              - [x] Allow the connection
                NEXT

              - [x] Domain
                [x] Private
                [x] Public
                NEXT

   6) Trouble shooting
      - first check if you can connect to the SSHD server on the same machine:
        - open a Cygwin terminal
        $ ssh -l [username] localhost
        
        If you can't connect to the server on localhost check if the sshd daemon is running (see blow)
   
      - check if the SSHD daemon is runing
        - open control panel
        - search for "services"
        - click on "View local services" 
        - search for "CYGWIN sshd"
        - make sure it's there, else try reinstalling sshd 
