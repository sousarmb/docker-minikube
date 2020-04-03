# docker-minikube
Files needed to build containers and run your (Microsoft Windows) local BOP dev environment in Docker or minikube. 

## Container images available:
* rmbsousa/4bop:php56 
* rmbsousa/4bop:php70_xdebug 
* rmbsousa/4bop:php70_xdebug_active 
* rmbsousa/4bop:php74_xdebug 
* rmbsousa/4bop:php74_xdebug_active 

## Use docker?
Download and install from [official source](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)

__Beware__: Docker will enable Hyper-V and this will disable both VMware and 
VirtualBox so you won't be able to use them until you disable Hyper-V again 
(... don't worry, it's easy and harmless to [switch Hyper-V on or off](https://www.youtube.com/watch?v=XJTeQdJUMDM), 
just takes a reboot)

Run `docker run -it -p 80:80 -v /host_drive_letter/directory/where/code/is:/guest_container_directory/from/where/code/will/serve rmbsousa/stuff:php56` 
to pull the image locally and start a container based on it.
 
After this you will be at the container prompt where you can do what it takes 
to configure the website. Check __config-webportal.sh__ to see how to.

Run `docker inspect container_id` to see container ip address and change your 
Windows hosts file accordingly.

## Use minikube?
Download and install from official source:
* [VirtualBox](https://download.virtualbox.org/virtualbox/6.1.4/VirtualBox-6.1.4-136177-Win.exe)
* [minikube](https://github.com/kubernetes/minikube/releases/download/v1.8.2/minikube-installer.exe) ([docs](https://kubernetes.io/docs/tasks/tools/install-minikube/))
* [kubectl](https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/windows/amd64/kubectl.exe) (... is a command, place in a directory registered in your host _%PATH%_) ([docs](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows))

Download as well:
* config-webportal.sh (not needed for Xdebug deployment)
* deployment-webportal.yml (for xXdebug use the _*-xdebug.yml_ version)
* ingress-services-servicebus-webportal.yml

### Choose container image to run
Default is php 7.0. If you want another php version edit __deployment-webportal[-xdebug].yml__ file and change line 21 (__image:__) to the container image you prefer.

Once you have downloaded and installed the previously listed software:
1. open a terminal or powershell
2. start the minikube cluster with `minikube start --vm-driver=virtualbox --cpus=2 --memory=4gb --disk-size=10gb --container-runtime=cri-o`
3. enable the [ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress/) with `minikube addons enable ingress` 
4. register [services](https://kubernetes.io/docs/concepts/services-networking/service/) and ingress controller with `kubectl create -f ingress-services-servicebus-webportal` 
5. [deploy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) with `kubectl create -f deployment-webportal[-xdebug].yml`.
6. start the dashboard with `minikube dashboard` to see the deployment status 
7. run `minikube ip` in a new terminal / powershell to get the cluster ip address and modify your hosts file accordingly 

## Using Xdebug?
Configure your IDE with the following (phpstorm 2020.1 EAP) settings ...

### minikube deployment (... without docker daemon)
You just need to configure:
* File \>\> Settings \>\> Languages & Frameworks \>\> PHP 
  * \>\> Debug
    * Go to "External Connections" and uncheck options:
      * "Ignore external..."
      * "Break at first..."
    * Go to "Xdebug"
      * set "Debug port" to 9001
      * check "Can accept external connections"
      * check "Resolve breakpoint..."
      * check "Force break at first line when no path..."
      * check "Force break at first line when a script..." 
  * ... \>\> Debug \>\> DBGp Proxy
      * set "IDE Key" to "PHPSTORM"
      * set "Port" to 9001
      
Also you need to install browser extension "Xdebug helper" for Chrome (i couldn't get the one for Firefox to work...), set "IDE key" to "PHPSTORM" and enable "Debug".

When you're ready to start debugging, click "Start listening for PHP debug connections" (phpstorm) button and refresh the browser page. The debug session should start at once.

## _Want to keep changes to your container?_
If you create any files inside the container or install new software and wish to keep in the container, create a new image based on the container with `docker commit [image_id] repository_name:tag_name`, create an [online repository](https://hub.docker.com/) and then `docker push repository_name:tag_name` to it.
