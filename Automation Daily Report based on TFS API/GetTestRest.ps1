$token = "xxx"
$at_result_uri="https://xxx.visualstudio.com/DefaultCollection/" $projectName "/_apis/test/runs/query?automated=true&api-version=2.0-preview"

#Sory the result by TestRunId so that the latest result can be retrived.

$query = @{
      query='Select * From TestRun order by TestRunId desc'
   }
$body = (ConvertTo-Json $query)
$base64authinfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "", $token)))
$responseFromGet = Invoke-RestMethod -Method Post -Body $body -ContentType application/json -Uri $at_result_uri -Headers @{Authorization=("Basic {0}" -f $base64authinfo)}
$EnvironmentName = ("dev-1", "Dev-1", "at-1","AT-1", "qa-1","QA-1")
$ServiceName = New-Object System.Collections.ArrayList
$ServiceName.Add('Microservice1')
$ServiceName.Add('Microservice2')
$ServiceName.Add('Microservice3')
$ServiceName.Add('Microservice4')
$ServiceName.Add('Microservice5')

# Sender's username and password
$username = "" 
$password = ""
# Receiver's list
$toList = ""
$message = new-object Net.Mail.MailMessage;
$message.From = "";
$message.To.Add($toList);
$message.Subject = "Release Test Report "+ (Get-Date -Format yyyyMMdd);
$message.Body = "<!DOCTYPE html>
<html>
<head>
<style>
body {
	color: #444;
	font: 100%/30px 'Helvetica Neue', helvetica, arial, sans-serif;
	text-shadow: 0 1px 0 #fff;
}

strong {
	font-weight: bold; 
}

em {
	font-style: italic; 
}

table {
	background: #f5f5f5;
	border-collapse: separate;
	box-shadow: inset 0 1px 0 #fff;
	font-size: 12px;
	line-height: 24px;
	margin: 30px auto;
	text-align: center;
	width: 100%;
}	

th {
	background-color: #008bbf;
	border-left: 1px solid #555;
	border-right: 1px solid #777;
	border-top: 1px solid #555;
	border-bottom: 1px solid #333;
	box-shadow: inset 0 1px 0 #999;
	color: #fff;
  font-weight: bold;
	padding: 10px 15px;
	position: relative;
	text-shadow: 0 1px 0 #000;	
}

th:after {
	background: linear-gradient(rgba(255,255,255,0), rgba(255,255,255,.08));
	content: '';
	display: block;
	height: 25%;
	left: 0;
	margin: 1px 0 0 0;
	position: absolute;
	top: 25%;
	width: 100%;
}

th:first-child {
	border-left: 1px solid #777;	
	box-shadow: inset 1px 1px 0 #999;
}

th:last-child {
	box-shadow: inset -1px 1px 0 #999;
}

td {
	border-right: 1px solid #fff;
	border-left: 1px solid #e8e8e8;
	border-top: 1px solid #fff;
	border-bottom: 1px solid #e8e8e8;
	position: relative;
	transition: all 300ms;
}

td:first-child {
	box-shadow: inset 1px 0 0 #fff;
}	

td:last-child {
	border-right: 1px solid #e8e8e8;
	box-shadow: inset -1px 0 0 #fff;
}	

tr {
	background: url(https://jackrugile.com/images/misc/noise-diagonal.png);	
}

tr:nth-child(odd) td {
	background: #f1f1f1 url(https://jackrugile.com/images/misc/noise-diagonal.png);	
}

tr:last-of-type td {
	box-shadow: inset 0 -1px 0 #fff; 
}

tr:last-of-type td:first-child {
	box-shadow: inset 1px -1px 0 #fff;
}	

tr:last-of-type td:last-child {
	box-shadow: inset -1px -1px 0 #fff;
}
</style>

</head>
<body>

<h2><center>Automation Daily Report</center></h2>
<table cellpadding="“0"” cellspacing=“"0"” border=""0"">
<thead>
  <tr>
    <th></th>
    <th><center>DEV-1</center></th> 
    <th><center>AT-1</center></th>
    <th><center>QA-1</center></th>
  </tr>
  </thead>
    <tbody>";

foreach ($element in $ServiceName){
    for($i=0;$i -lt $responseFromGet.count; $i++){
        if($responseFromGet.value[$i].name.StartsWith((  $EnvironmentName[0]+" "+$element+" Service Component Tests")) -or $responseFromGet.value[$i].name.StartsWith(('Plexure-'+ $EnvironmentName[1]+" "+$element+" Service Component Tests"))) {
            $totalRes=$responseFromGet.value[$i].totalTests; 
            $passRes=$responseFromGet.value[$i].passedTests; 
            $url=$responseFromGet.value[$i].webAccessUrl; 
            $runId=$responseFromGet.value[$i].id;
            $passRate=[double]($passRes/$totalRes)*100;
            $passRate=[System.Math]::Round($passRate,2);
            $message.Body+="<tr>
            <td>"+$element+"</td>
            <td><a href=""$url&_a=resultQuery""";
            if($passRate -ne 100)
            {
            $message.Body += "style=""color:red""";
            }
            $message.Body += ">" + $passRate + "%</a></td><td>";
            for($j=0;$j -lt $responseFromGet.count; $j++){
                if($responseFromGet.value[$j].name.StartsWith((  $EnvironmentName[2]+" "+$element+" Service Component Tests")) -or $responseFromGet.value[$j].name.StartsWith(('Plexure-'+ $EnvironmentName[3]+" "+$element+" Service Component Tests"))) {
                    $totalRes=$responseFromGet.value[$j].totalTests; 
                    $passRes=$responseFromGet.value[$j].passedTests; 
                    $url=$responseFromGet.value[$j].webAccessUrl; 
                    $runId=$responseFromGet.value[$j].id;
                    $passRate=[double]($passRes/$totalRes)*100;
                    $passRate=[System.Math]::Round($passRate,2);
                    $message.Body +="<a href=""$url&_a=resultQuery""";
                    if($passRate -ne 100)
                    {
                    $message.Body += "style=""color:red""";
                    }
                    $message.Body += ">" + $passRate + "%</a>";
                    break;
                }
            }
            $message.Body+="</td><td>";
            for($k=0;$k -lt $responseFromGet.count; $k++){
                if($responseFromGet.value[$k].name.StartsWith((  $EnvironmentName[4]+" "+$element+" Service Component Tests")) -or $responseFromGet.value[$k].name.StartsWith(('Plexure-'+ $EnvironmentName[5]+" "+$element+" Service Component Tests"))) {
                    $totalRes=$responseFromGet.value[$k].totalTests; 
                    $passRes=$responseFromGet.value[$k].passedTests; 
                    $url=$responseFromGet.value[$k].webAccessUrl; 
                    $runId=$responseFromGet.value[$k].id;
                    $passRate=[double]($passRes/$totalRes)*100;
                    $passRate=[System.Math]::Round($passRate,2);
                    $message.Body +="<a href=""$url&_a=resultQuery""";
                    if($passRate -ne 100)
                    {
                    $message.Body += "style=""color:red""";
                    }
                    $message.Body += ">" + $passRate + "%</a>";
                    break;
                }
            }
            $message.Body+="</td></tr>";
            break;
        }
    }
}

$message.Body+="
</tbody>  
</table>
</body>
</html>"


$smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
$smtp.EnableSSL = $true;
$message.IsBodyHtml=$true
$smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password);
$smtp.send($message);
