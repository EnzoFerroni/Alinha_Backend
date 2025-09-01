<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&color=0:FF0000,100:00FFFF&height=200&section=header&text=Alinha&fontSize=50&fontColor=fff&animation=twinkling&fontAlignY=40">

<p align="left">
  <i>🤔💭 Backend para aplicativo de registros de atendimentos com mentores específicos para instituições.
.</i>
</p>

<p align="left">
  <i>🤔💭 Backend for an application that records appointments with specific mentors for institutions.</i>
</p>

## Class Diagram
<img width="1426" height="741" alt="image" src="https://github.com/user-attachments/assets/196ca5de-320e-4cbd-aded-bc0693807afe"/>

## Rotas de usuário 


* ###  GET em …/users 

	* Retorna todos os usuários do aplicativo.
	* Status Code de sucesso: 200 OK.

* ### GET em …/users/:id
  * Trocar “:id” pelo id do usuário que deseja buscar.
  * Status Code de sucesso: 200 OK.
  *  Caso onde o id do usuário não foi encontrado: 400 Bad Request.

* ### POST em …/users 
  * Cria um usuário no banco de dados.
  * Status Code de sucesso: 200 OK.
  * Caso de errar a confirmação de senha: 400 Bad Request.
  * Formato do JSON: 

```
	{ 
		“name”: “”,
		“email”: “”,
		“password”: “”,
		“confirmedPassword”: “”,
		“role”: “"
	}

```
	
  
* Opções de role: “adm”, “mentor" e “student”.
* JSON de resposta:

 ```
	{ 
		“id”: “”,
		“email”: ""
	}

```

* ### DELETE em …/users/:id 
  * Deleta um usuário pelo id.
  * Trocar “:id” pelo id do usuário que deseja deletar.
  * Status Code de sucesso: 200 OK.
  * Caso onde o id do usuário não foi encontrado: 400 Bad Request.

* ### PATCH em …/users/:updateName
  * Atualiza o nome do usuário.
  * Status Code de sucesso: 200 OK.
  * Caso onde o id do usuário não foi encontrado: 400 Bad Request.
  * Formato do JSON:
  
  ``` 
    { 
        “id”: “UUID”,
        “name”: “”,
    } 
    
  ```
  
  * JSON de resposta: 
    
``` 

    { 
		“id”: “UUID”,
		“name”: “”,
		“email”: “”,
		“password”: “”,
		“role”: “”,
		“path”: “”,
	}

```

## Rotas de agendamento 

* ###  GET em …/:appointments 
	* Retorna todos os agendamentos
	* Status Code de sucesso: 200 OK.

* ### GET em …/appointments/:appointmentID
	* Retorna um agendamento especifico
	* Trocar “:appointmentID” pelo id do appointment que deseja buscar.
	* Status Code de sucesso: 200 OK.
	* Caso onde o id do agendamento não foi encontrado: 400 Bad Request.

* ### POST em …/:appointments 
	* Cria um agendamento no banco de dados. 
	* Status Code de sucesso: 200 OK.
	* Formato do JSON: 
    
    ``` 
	{ 
		“mentor”: “”,
		“appointmentPlace”: “”,
		“description”: “",
		“studentiD”: “”,
		“isScheduled”: “”,
		“callStudent”: “”,
		“isDone”: “”,
		“type”: “”,
		“path":""
	} 
    
	```


	* Opções de appointmentCategory: “code”, “design".
	* Opções de appointmentType: “doubt”, “problem”.
	* JSON de resposta:



```	

    { 
		“id”: "UUID"
		“mentor”: “String”,
		“studentID”: “UUID”,
		“description”:"String,"
		“appointmentPlace”: “String”,
		“isScheduled”: “Bool”
		“callStudent”: “Bool”
		“isDone”: “Bool"
		“createdAt”: "Date"	
		“type”: "TypeAppointment",
		“path":"PathAppointment"
	} 
    
```

* ### PATCH em …/appointments/place
	* Atualiza os locais de agendamento. 
	* Status Code de sucesso: 200 OK.
	* Caso onde o id do agendamento não foi encontrado: 400 Bad Request.
	* Formato do JSON: 

```	

    { 
		“appointmentId”: “UUID”,
		“appointmentPlace”: “String”,
	} 
    
```

* JSON de resposta: 

 
 ``` 
    
	{ 
		“id”: "UUID"
		“mentor”: “String”,
		“studentID”: “UUID”,
		“description”:"String,"
		“appointmentPlace”: “String”,
		“isScheduled”: “Bool”
		“callStudent”: “Bool”
		“isDone”: “Bool"
		“createdAt”: "Date"	
		“type”: "TypeAppointment",
		“path”:"PathAppointment"
	}
    
```


* ### PATCH em …/appointments/isScheduled 
	* Atualiza status do agendamento. 
	* Status Code de sucesso: 200 OK.
	* Caso onde o id do agendamento não foi encontrado: 400 Bad Request.
	* Formato do JSON: 

	``` 	

	    { 
			“appointmentId”: “UUID”,
			“isScheduled”: “Bool”,
		} 
    
	```

	* JSON de resposta: 


	``` 	

	    { 
			“id”: "UUID"
			“mentor”: “String”,
			“studentID”: “UUID”,
			“description”:"String,"
			“appointmentPlace”: “String”,
			“isScheduled”: “Bool”
			“callStudent”: “Bool”
			“isDone”: “Bool"
			“createdAt”: "Date"	
			“type”: "TypeAppointment",
			“path":"PathAppointment"
		}
    
	```

* ### PATCH em …/appointments/callStudent 
	* Atualiza status de chamada do estudante. 
	* Status Code de sucesso: 200 OK.
	* Caso onde o id do agendamento não foi encontrado: 400 Bad Request.
	* Formato do JSON: 
 
 	```   
		{ 
			“appointmentId”: “UUID”,
			“callStudent”: “Bool”,
		}

	```

	* JSON de resposta: 

	
 	```
 
		{ 
			“id”: "UUID"
			“mentor”: “String”,
			“studentID”: “UUID”,
			“description”:"String,"
			“appointmentPlace”: “String”,
			“isScheduled”: “Bool”
			“callStudent”: “Bool”
			“isDone”: “Bool"
			“createdAt”: "Date"	
			“type”: "TypeAppointment",
			“path”:"PathAppointment"
		}

	```

* ### PATCH em …/appointments/isDone 
	* Atualiza status de chamada do estudante. 
	* Status Code de sucesso: 200 OK.
	* Caso onde o id do agendamento não foi encontrado: 400 Bad Request.
	* Formato do JSON: 

	``` 	
	
	    { 
			“appointmentId”: “UUID”,
			“isDone”: “Bool”,
		} 
	    
	```
 
	* JSON de resposta: 
	 
	 ```
     
		{ 
			“id”: "UUID"
			“mentor”: “String”,
			“studentID”: “UUID”,
			“description”:"String,"
			“appointmentPlace”: “String”,
			“isScheduled”: “Bool”
			“callStudent”: “Bool”
			“isDone”: “Bool"
			“createdAt”: "Date"	
			“type”: "TypeAppointment",
			“path”:"PathAppointment"
		}
  
	```

* ### PATCH em …/appointments/mentor 
	* Atualiza o mentor ao qual o agendamento está associado. 
	* Status Code de sucesso: 200 OK.
	* Caso onde o id do agendamento não foi encontrado: 400 Bad Request.
	* Formato do JSON: 
	
	``` 	
	
	    { 
			“appointmentId”: “UUID”,
			“mentor”: “User”,
		} 
	    
	```

	* JSON de resposta:

    
	```  	
	
	    { 
			“id”: "UUID"
			“mentor”: “String”,
			“studentID”: “UUID”,
			“description”:"String,"
			“appointmentPlace”: “String”,
			“isScheduled”: “Bool”
			“callStudent”: “Bool”
			“isDone”: “Bool"
			“createdAt”: "Date"	
			“type”: "TypeAppointment",
			“path”:"PathAppointment"	
		} 
	    
	```	

* ### DELETE em …/appointments/:appointmentID 
	* Trocar “:appointmentID” pelo id do agendamento que deseja deletar.
	* Status Code de sucesso: 200 OK.
	* Caso onde o id do agendamento não foi encontrado: 400 Bad Request.



### 👤 Authors | Autores
<div align="left">

<table>
  <tr>
    <td align="center">
      <a href="https://www.linkedin.com/in/carolina-sun/" target="_blank">
        <img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn" height="20"/>
      </a>
    </td>
    <td>Carolina Sun</td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://www.linkedin.com/in/enzoferroni/" target="_blank">
        <img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn" height="20"/>
      </a>
    </td>
    <td>Enzo Ferronin</td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://www.linkedin.com/in/dayo-araujo/" target="_blank">
        <img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn" height="20"/>
      </a>
    </td>
    <td>Dayô Araújo</td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://www.linkedin.com/in/jo%C3%A3o-vitor-rocha-miranda-/" target="_blank">
        <img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn" height="20"/>
      </a>
    </td>
    <td>João Vitor Rocha Miranda
</td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://www.linkedin.com/in/pedrotessaro/" target="_blank">
        <img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn" height="20"/>
      </a>
    </td>
    <td>Pedro Tessaro Augusto</td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://www.linkedin.com/in/rafael-oneves/" target="_blank">
        <img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn" height="20"/>
      </a>
    </td>
    <td>Rafael Neves</td>
  </tr>
</table>

</div>
