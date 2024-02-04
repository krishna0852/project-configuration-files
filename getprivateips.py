import boto3 


sess=boto3.Session(aws_access_key_id='', 
                aws_secret_access_key='',
                region_name='ap-southeast-2')

ec2=sess.resource("ec2")


def getPrivateipOnTags():
    instance_names=['master','pract-cluster-spot-nodes-Node'] 
    for instance_name in instance_names:
          print('filtering started')
          instances=ec2.instances.filter(Filters=[
            {
             'Name': 'tag:Name',
             'Values': [instance_name]
             }
             ]
        )
          print('filtering-end')
          for instance in instances:
            print('entered child for loop')
            if instance.private_ip_address:
                print('entered into if-block')
                private_ip=instance.private_ip_address
                putipInToHostFile(instance_name,private_ip)
                    
          

def putipInToHostFile(name, ipaddress):
    # print(name)
    # print(ipaddress)
    filename='inventory-host'
    print('opening file')
    with open(filename, 'a') as file:
       print('writing into file')
       file.write(f"[{name}]\n{ipaddress}\n")



call=getPrivateipOnTags()






      
     
        

     









