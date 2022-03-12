# Build data cycle function
function delete{Param([string]$file)
$uri='https://${NEXTCLOUDDOMAIN}/remote.php/dav/files/m.ghiffari/%d8%a7%d9%84%d9%86%d9%81%d8%b3/'; $uri+=$file;
$param = @{uri = $uri; Method = 'DELETE';
           Headers = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$USER:$PASS"));}
}
Invoke-RestMethod @param
}

function post{Param([string]$file)
$uri='https://${NEXTCLOUDDOMAIN}/remote.php/dav/files/m.ghiffari/%d8%a7%d9%84%d9%86%d9%81%d8%b3/'; $uri+=$file; $infille=Join-Path C:\Users\Admin\Pics\ $file;
$param = @{uri = $uri; InFile = $infille; Method = 'PUT';
           Headers = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$USER:$PASS"));}
}
Invoke-RestMethod @param
}

function get{Param([string]$file)
$uri='https://${NEXTCLOUDDOMAIN}/remote.php/ocs/v1.php/apps/files_sharing/api/v1/shares';
$param = @{uri = $uri; Method = 'GET';
           Headers = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$USER:$PASS"));}
}
([xml](Invoke-RestMethod @param)).ocs.data.element | Where-Object {$_.file_target -Match "$file"}
}

## Execute cycle to NextCloud & Fetch share URL
Delete -file 1.PNG; Post -file 1.PNG; $file+= $(Get -file 1.PNG)
Delete -file 2.PNG; Post -file 2.PNG; $file+= $(Get -file 2.PNG)
Delete -file 3.PNG; Post -file 3.PNG; $file+= $(Get -file 3.PNG)

### Post share URL Nextcloud to Slack platform
$pay=@'
{
"channel": "GHX93A848",
  "username": "Zabbix Capture",
  "icon_emoji": ":camera_with_flash:",
  "attachments": [
{
 "text": "Zabbix Public Web",
 "color": "#00ff33",
 "image_url": "
'@
$load=@'
"}]}
'@
Invoke-RestMethod -Uri https://hooks.slack.com/services/$TENANT/$CHANNEL/$WEBHOOK -Body $pay$file$load -ContentType "application/json" -Method Post
