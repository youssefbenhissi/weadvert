var crypto = require('crypto');
//const multer = require('multer');
var uuid = require ('uuid');
var express = require('express');
//var multer, storage, path, crypto;
multer = require('multer')
path = require('path');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var app = express();
var fs = require('fs');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const jwt_decode = require('jwt-decode');

//const socket = require('socket.io');
var  QRCode  = require ( 'qrcode' ) 
var nodemailer = require('nodemailer');
var randomize = require('randomatic');
const { url } = require('inspector');
const toFile = require('data-uri-to-file');
global.atob = require("atob");
global.Blob = require('node-blob');
app.use(bodyParser.json()); // Accept JSON params
app.use(bodyParser.urlencoded({extended:true})); //Accept UrlEncoded params

app.use(cors());
//Connect to MySQL
var mysqlHost = process.env.MYSQL_HOST || 'localhost';
var mysqlPort = process.env.MYSQL_PORT || '3306';
var mysqlUser = process.env.MYSQL_USER || 'root';
var mysqlPass = process.env.MYSQL_PASS || '';
var mysqlDB = process.env.MYSQL_DB || 'weadvert';

var con = mysql.createConnection({
  host: mysqlHost,
  port: mysqlPort,
  user: mysqlUser,
  password: mysqlPass,
  database: mysqlDB
});
app.listen(3305,()=>{
    console.log('Restful Running on port 3305');
});
con.connect((err)=> {
    if(!err)
        console.log('Connection Established Successfully');
    else
        console.log('Connection Failed!'+ JSON.stringify(err,undefined,2));
});
module.exports = con;

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, './images');
      var fileName;
  
    },
    filename: function (req, file, cb) {
      fileName=file.originalname;
      cb(null, file.originalname);
    }
  });
  
  
  const fileFilter = (req, file, cb) => {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/jpg' || file.mimetype === 'image/png') {
      cb(null, true);
    } else {
      cb(null, false)
    }
  };
  
  
  const upload = multer({
    storage: storage,
    limits: {
      fileSize: 1024 * 1024 * 5
    },
    fileFilter: fileFilter
  });
  
  
  app.post("/add_group_image", upload.single('imgName'), (req, res, next) => {
       res.send();
    }, (error, req, res, next) => {
        res.status(400).send({error: error.message})
  });
  
  app.get('/file/:fileName', function (req, res) {
      var options = {
      root: path.join(__dirname, 'images'),
      dotfiles: 'deny',
      headers: {
        'x-timestamp': Date.now(),
        'x-sent': true
      }
    }
  
    var fileName = req.params.fileName
    res.sendFile(fileName, options, function (err) {
      if (err) {
        //res.json("pas d'image")
      } else {
        console.log('Sent:', fileName)
      }
    })
  });
   

////////////////////////////////////////////////////////////////////////////////////////////////////login automobiliste /////////////////////////////////////:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////LOGIN//////////////////////////////////////////////::
app.post('/loginautomobiliste',(req,res,next)=>{
    var post_data = req.body;

    //Extract email and password from request
    var user_password = post_data.password;
    var email = post_data.email;

    con.query('SELECT * FROM utilisateur u, automobiliste a where u.email=? and STRCMP (u.email,a.email) = 0 and u.role = 0 ',[email],function (err,result,fields) {
        con.on('error', function (err) {
            console.log('[MYSQL ERROR]', err);
        });
        if (result && result.length)

        {
            var salt = result[0].salt;
            var encrypted_password = result[0].encrypted_password;
            var hashed_password = checkHashPassword(user_password, salt).passwordHash;
            if (encrypted_password == hashed_password){
                res.status(200).send(JSON.stringify(result[0]))
                con.query("UPDATE utilisateur SET nbrdefois = 0 WHERE email = ?", [email]);
            }
            //res.end(JSON.stringify(result[0]))
            else{
                con.query("UPDATE utilisateur SET nbrdefois = ( nbrdefois + 1 ) WHERE email = ?", [email]);
                res.status(202).send(JSON.stringify(result[0]))
            }
        }

        else {
            res.status(400).send()
            }

    });


})




////////////////////////////////////////////////////////////////////////////////////////////////////////////////LOGIN//////////////////////////////////////////////::
app.post('/loginbusiness',(req,res,next)=>{
  var post_data = req.body;

  //Extract email and password from request
  var user_password = post_data.password;
  var email = post_data.email;

  con.query('SELECT * FROM utilisateur u, annonceur a where u.email=? and STRCMP (u.email,a.email) = 0 and u.role = 1 ',[email],function (err,result,fields) {
      con.on('error', function (err) {
          console.log('[MYSQL ERROR]', err);
      });
      if (result && result.length)

      {
          var salt = result[0].salt;
          var encrypted_password = result[0].encrypted_password;
          var hashed_password = checkHashPassword(user_password, salt).passwordHash;
          if (encrypted_password == hashed_password){
              res.status(200).send(JSON.stringify(result[0]))
              con.query("UPDATE utilisateur SET nbrdefois = 0 WHERE email = ?", [email]);
          }
          //res.end(JSON.stringify(result[0]))
          else{
              con.query("UPDATE utilisateur SET nbrdefois = ( nbrdefois + 1 ) WHERE email = ?", [email]);
              res.status(202).send(JSON.stringify(result[0]))
          }
      }

      else {
          res.status(400).send()
          }

  });


})


//////////////////////////////////////////////////////////////////////////////////////////////:REGISTER//////////////////////////////////////
//PASSWORD CRYPT
var genRandomString = function (length) {
    return crypto.randomBytes(Math.ceil(length/2))
        .toString('hex') //Convert to hexa format
        .slice(0,length);
    
};
var sha512 = function (password,salt) {
    var hash = crypto.createHmac('sha512',salt) ; //Use SHA512
    hash.update(password);
    var value = hash.digest('hex');
    return {
        salt:salt,
        passwordHash:value
    };
    
};
function saltHashPassword(userPassword) {
    var salt = genRandomString(16); //Gen Random string with 16 charachters
    var passwordData = sha512(userPassword,salt) ;
    return passwordData;
    
}
function checkHashPassword(userPassword,salt) {
    var passwordData = sha512(userPassword,salt);
    return passwordData;
    
}
var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'youssef.benhissi@esprit.tn',
      pass: 'ilovetennis'
    }
  });
function sendVerificationEmail(email,randomCode)
{
	var mailOptions = {
		from: 'youssef.benhissi@esprit.tn',
		to: email,
		subject: 'Account Verification',
		html: "<p>You can use this code to verify your account: "+randomCode+".</p>"
	};
	transporter.sendMail(mailOptions, function(error, info){
	if (error) 
	{
		console.log(error);
	} 
	else 
	{
		console.log('Email sent: ' + info.response);
	}
	});
}
/////////////////////////////////////////////////////////////////////////////////////////////REGISTER USER//////////////////////////////
app.post('/register',(req,res,next)=>{
    var post_data = req.body;  //Get POST params
    var uid = uuid.v4();   //Get  UUID V4
    var plaint_password = post_data.password ;  //Get password from post params
    var hash_data = saltHashPassword(plaint_password);
    var password = hash_data.passwordHash;  //Get Hash value
    var salt = hash_data.salt; 
    var email = post_data.email;

    con.query('SELECT * FROM utilisateur where email=?',[email],function (err,result,fields) {
        con.on('error',function (err) {
            console.log('[MYSQL ERROR]',err);
            
        });
        if (result && result.length)
        res.status(409).send()
        else {
            let randomCode = randomize('0', 4);
            con.query('INSERT INTO `utilisateur`(`unique_id` , `email`, `encrypted_password`, `salt`, `created_at`, `updated_at`, `nbrdefois`,`etat`,`verification_code`,`role`) ' +
                'VALUES (?,?,?,?,NOW(),NOW(),0,0,?,0)',[uid,email,password,salt,randomCode],function (err,result,fields) {
                if (err) throw err;
                let resultId = result.insertId;
			//	sendVerificationEmail(email,randomCode);
      res.status(200).send(randomCode)
                //res.json('Register successfully !');

            })
				
        }
    });

})
/////////////////////////////////////////////////////////////////////////////////////////////REGISTER USER//////////////////////////////
app.post('/registerbusiness',(req,res,next)=>{
  var post_data = req.body;  //Get POST params
  var uid = uuid.v4();   //Get  UUID V4
  var plaint_password = post_data.password ;  //Get password from post params
  var hash_data = saltHashPassword(plaint_password);
  var password = hash_data.passwordHash;  //Get Hash value
  var salt = hash_data.salt; 
  var email = post_data.email;

  con.query('SELECT * FROM utilisateur where email=?',[email],function (err,result,fields) {
      con.on('error',function (err) {
          console.log('[MYSQL ERROR]',err);
          
      });
      if (result && result.length)
      res.status(409).send()
      else {
          let randomCode = randomize('0', 4);
          con.query('INSERT INTO `utilisateur`(`unique_id` , `email`, `encrypted_password`, `salt`, `created_at`, `updated_at`, `nbrdefois`,`etat`,`verification_code`,`role`) ' +
              'VALUES (?,?,?,?,NOW(),NOW(),0,0,?,1)',[uid,email,password,salt,randomCode],function (err,result,fields) {
              if (err) throw err;
              let resultId = result.insertId;
    //	sendVerificationEmail(email,randomCode);
    res.status(200).send(randomCode)
              //res.json('Register successfully !');

          })
      
      }
  });

})
/////////////////////////////////////////////////////////////////////////////REGISTER AUTOMOBILSTE/////////////////////////////////////:
app.post("/ajouterautomobilste", function(req, res)
{
    let nom = req.body.nom;
    let prenom = req.body.prenom;
    let email = req.body.email;
    let profession = req.body.profession;
    let lieuCirculation = req.body.lieuCirculation;
    let numerotelephone = req.body.numerotelephone;
    
			con.query('INSERT INTO `automobiliste` (`nom`, `prenom`,`email`,`profession`,`lieuCirculation`,`numerotelephone`) ' +
            'VALUES (?,?,?,?,?,?)',[nom,prenom,email,profession,lieuCirculation,numerotelephone]);
			res.status(200).send()

});

/////////////////////////////////////////////////////////////////////////////////////////////////USER VERIFICATION///////////////////////////////////: 


function verifyUser(user, code, cb)
{
	con.query("SELECT * FROM utilisateur WHERE email = ? AND verification_code = ?", [user, code],
		function(err, result)
		{
			if (err) throw err;
			cb(result);
		}
	);
}
app.post("/verify_user", function(req, res)
{
	let email = req.body.email;
	let code = req.body.code;
	verifyUser(email, code, function(result)
	{
		let length = result.length;
		if (length == 0)
		{
			res.status(202).send()
		}
		else
		{
            con.query('SELECT * FROM utilisateur where email=?',[email],function (err,result,fields){
                con.query("UPDATE utilisateur SET etat = '1' WHERE email = ?", [email]);
                if (result && result.length){
                    res.status(200).send(JSON.stringify(result[0]))
                }
			    //res.status(200).send()
            });
			
		}
	});
});
/////////////////////////////////////////////////////////////////////////////////automobiliste get /////////////////////////////////////:
//Get id User
app.post('/getIdAutomobiliste', function (req, res) {
  let email = req.body.email;
  con.query('SELECT * FROM automobiliste  WHERE email = ? ', [email], function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});

///////////////////////////////////////////////////////////////////////////////Ajouter une offre ///////////////////////

app.post("/ajouteroffre", function(req, res)
{
    let idAnnonceur = req.body.idAnnonceur;
    let description = req.body.description;
    let gouvernorat = req.body.gouvernorat;
    let dateDeb = req.body.datedebut;
    let dateFin = req.body.datefin;
    let nbCandidats = req.body.nbcandidats;
    let cout = req.body.cout;
    let renouvelable = req.body.renouvelable;
    let imageOffer = req.body.imageOffer;
    let typeoffre = req.body.typeoffre;
    
			con.query('INSERT INTO `offre` (`idAnnonceur`, `description`,`gouvernorat`,`dateDeb`,`dateFin`,`nbCandidats`,`cout`,`renouvelable`,`imageOffer`,`typeoffre`) ' +
            'VALUES (?,?,?,?,?,?,?,?,?,?)',[idAnnonceur,description,gouvernorat,dateDeb,dateFin,nbCandidats,cout,renouvelable,imageOffer,typeoffre]);
			res.status(200).send()

});

/////////////////////////////////////////////////////////////GET TOUS LES AFFORES
app.get('/gettousoffres', function (req, res) {
  //let email = req.body.email;
  con.query('SELECT * FROM offre ORDER BY RAND()', function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});



/////////////////////////////////////////////////////////////GET TOUS LES AFFORES ordonnes par date descroissante
app.get('/gettousoffresnewones', function (req, res) {
  //let email = req.body.email;
  con.query('SELECT * FROM offre ORDER BY dateDeb DESC', function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});


/////////////////////////////////////////////////////////////GET TOUS LES AFFORES ordonnes par likes descroissante
app.get('/gettousoffresliked', function (req, res) {
  //let email = req.body.email;
  con.query('SELECT * FROM offre ORDER BY likes DESC', function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});

/////////////////////////////////////////////////////////////////////////// somme couts ////////////////////////
app.post('/sommecouts', function (req, res) {
  let idAnnonceur = req.body.idAnnonceur;
  con.query('SELECT SUM(cout) as somme FROM offre  WHERE idAnnonceur = ? ', [idAnnonceur], function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});

/////////////////////////////////////////////////////////////////////////// somme offres ////////////////////////
app.post('/sommeoffres', function (req, res) {
  let idAnnonceur = req.body.idAnnonceur;
  con.query('SELECT COUNT(*) as somme FROM offre  WHERE idAnnonceur = ? ', [idAnnonceur], function (error, results, fields) {
      if (error) throw error;
      return res.status(202).send(results);
  });
});


/////////////////////////////////////////////////////////////////////////// somme offres ////////////////////////
app.post('/sommecoutsss', function (req, res) {
  let idAnnonceur = req.body.idAnnonceur;
  con.query('SELECT * FROM offre  WHERE idAnnonceur = ? ', [idAnnonceur], function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});



/////////////////////////////////////////////////////////////////////////// somme offres ////////////////////////
app.post('/stat', function (req, res) {
  let idAnnonceur = req.body.idAnnonceur;
  con.query('SELECT FLOOR((MONTH(dateDeb))/3)+1 semester , COUNT(*) valeur FROM offre where idAnnonceur = ? GROUP BY FLOOR((MONTH(dateDeb))/3)', [idAnnonceur], function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});
/////////////////////////////////////////////////////////////////////////////selectionner des offres selon region //////////
app.post('/offreregion', function (req, res) {
  let region = req.body.region;
  con.query("SELECT * FROM offre o, annonceur a WHERE a.idAnnonceur = o.idAnnonceur AND NOT STRCMP(o.gouvernorat,?)  ", [region], function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});


/////////////////////////////////////////////////////////////////////////////////////////////AJOUTER CANDIDATURE//////////////////////////////
app.post('/ajoutercandidature',(req,res,next)=>{
  var post_data = req.body; 
  var idoffre = post_data.idoffre ;  //Get password from post params
  var idautomobiliste = post_data.idautomobiliste ;  //Get password from post params
  con.query('SELECT * FROM candidature where  idOffre = ? AND idautomobiliste = ?',[idoffre,idautomobiliste],function (err,result,fields) {
      con.on('error',function (err) {
          console.log('[MYSQL ERROR]',err);
          
      });
      if (result && result.length)
        res.status(409).send()
      else {
            con.query('INSERT INTO `candidature`(`idOffre` , `etatValidation`,`idautomobiliste`,`idAuto`) ' +
              'VALUES (?,0,?,?)',[idoffre,idautomobiliste,idautomobiliste],function (error,result,fields) {
                if (error) throw error;
          res.status(202).send()
          })
      
      }
  });

})


/////////////////////////////////////////////////////////////////////////////////////////////AJOUTER CANDIDATURE//////////////////////////////
app.post('/verifiercandidature',(req,res,next)=>{
  var post_data = req.body; 
  var idoffre = post_data.idoffre ;  //Get password from post params
  var idautomobiliste = post_data.idautomobiliste ;  //Get password from post params
  con.query('SELECT * FROM candidature where  idOffre = ? AND idautomobiliste = ?',[idoffre,idautomobiliste],function (err,result,fields) {
      con.on('error',function (err) {
          console.log('[MYSQL ERROR]',err);
          
      });
      if (result && result.length)
        res.status(409).send()
      else{
        res.status(202).send()
      }
      
  });

})


/////////////////////////////////////////////////////////////////////////////verifier rating //////////
app.post('/verifierrating', function (req, res) {
  let idautomobiliste = req.body.idautomobiliste;
  let idoffre = req.body.idoffre;
  con.query("SELECT * FROM ratingoffre r, candidature c WHERE r.idautomobiliste = c.idautomobiliste AND c.etatValidation = 1 AND c.idautomobiliste = ? AND r.idoffre = c.idOffre AND r.idoffre = ?", [idautomobiliste,idoffre], function (error, result, fields) {
      if (error) throw error;
      if (result && result.length)
        res.status(200).send()
      else{
        res.status(202).send()
      }
  });
});
app.post("/ajouterratingoffre", function(req, res)
{
	let likes = req.body.likes;
	let nbrdefois = req.body.nbrdefois;
	let somme = req.body.somme;
	let idoffre = req.body.idoffre;
			con.query("UPDATE `offre` SET `likes` =  ? , `nbrdefois` = ? , `somme` = ? WHERE `idOffre` = ?", [likes,nbrdefois,somme,idoffre], function (error, results, fields) {
        if (error) throw error;
        res.status(200).send()
      });
			
		
	
});



/////////////////////////////////////////////////////////////////////////////selectionner les automobilistes selon les offres //////////
app.post('/selectautomiblistesseloncandidature', function (req, res) {
  let idautomobiliste = req.body.idautomobiliste;
  con.query("SELECT * FROM automobiliste a, candidature c WHERE c.idautomobiliste = a.idAuto AND c.idOffre = ?", [idautomobiliste], function (error, result, fields) {
      if (error) throw error;
      if (result && result.length) 
        res.status(200).send(result)
      else{
        res.status(202).send()
      }
  });
});

//////////////////////////////////////////////////////////////////////////////////////////////////send qrcode////////////////////////////
function sendQRcodeEmail(email,data,namefile)
{
    let randomCode = randomize('0', 5);
	var mailOptions = {
		from: 'youssef.benhissi@esprit.tn',
		to: email,
		subject: 'Account Verification',
        html: "Veuillez montrer ce Qr code au livreur quand il arrive",
        attachments: [  
            {   
                filename: "you.png",    
                
                path : "C:/Users/DELL/Desktop/pim/node/images/you.png"            
            }  
        ] 
	};
	transporter.sendMail(mailOptions, function(error, info){
	if (error) 
	{
		console.log(error);
	} 
	else 
	{
		console.log('Email sent: ' + info.response);
		
	}
	});
}
app.post("/youssefyoussef", function(req, res){
  sendQRcodeEmail("youssef.benhissi@esprit.tn","123");
});




/////////////////////////////////////////////////////////////////////////////somme des couts //////////
app.post('/sommedescouts', function (req, res) {
  let region = req.body.region;
  con.query("SELECT SUM(o.cout) as somme FROM offre o WHERE o.idAnnonceur = ? ", [region], function (error, results, fields) {
      if (error) throw error;
     // con.query("UPDATE offre SET cout = 0 WHERE idAnnonceur = ?", [region]);
      return res.send(results);
  });
});
///////////////////////////////////////////////////////////////////////////// clearsomme des couts //////////
app.post('/clearsommedescouts', function (req, res) {
  let region = req.body.region;
  let somme = req.body.somme;
  con.query("UPDATE offre SET cout = 0 WHERE idAnnonceur = ?", [region]);
  con.query('INSERT INTO `payment` (`idAnnonceur`, `date`,`somme`) ' +
  'VALUES (?,NOW(),?)',[region,somme]);

});



/////////////////////////////////////////////////////////////////////////////AJOUTER PAYMENT /////////////////////////////////////:
app.post("/ajouterpayment", function(req, res)
{
    let nom = req.body.nom;
    let prenom = req.body.prenom;
    let email = req.body.email;
    let profession = req.body.profession;
    let lieuCirculation = req.body.lieuCirculation;
    let numerotelephone = req.body.numerotelephone;
    
			con.query('INSERT INTO `automobiliste` (`nom`, `prenom`,`email`,`profession`,`lieuCirculation`,`numerotelephone`) ' +
            'VALUES (?,?,?,?,?,?)',[nom,prenom,email,profession,lieuCirculation,numerotelephone]);
			res.status(200).send()

});

/////////////////////////////////////////////////////////////////////////// somme offres ////////////////////////
app.post('/statpayment', function (req, res) {
  let idAnnonceur = req.body.idAnnonceur;
  con.query('SELECT FLOOR((MONTH(date))/3)+1 semester , SUM(somme) valeur FROM payment where idAnnonceur = ? GROUP BY FLOOR((MONTH(date))/3)', [idAnnonceur], function (error, results, fields) {
      if (error) throw error;
      return res.send(results);
  });
});
/////////////////////////////////////////////////////////////////////////////REGISTER AUTOMOBILSTE/////////////////////////////////////:
app.post("/ajouterbusinesscomplete", function(req, res)
{
    let entreprise = req.body.entreprise;
    let typeentre = req.body.typeentre;
    let email = req.body.email;
    let telephone = req.body.telephone;
    let website = req.body.website;
    
			con.query('INSERT INTO `annonceur` (`entreprise`, `typeEntre`,`email`,`etatValidation`,`telephone`,`website`) ' +
            'VALUES (?,?,?,0,?,?)',[entreprise,typeentre,email,telephone,website]);
			res.status(200).send()

});





/////////////////////////////DALI////////////////::
function sendForgotPasswordEmail(email, idAuto) {
	let randomCode = randomize('0', 5);
	var mailOptions = {
		from: 'WeAdvert.app.contact@gmail.com',
		to: email,
		subject: 'Reset your password',
		html:
		"<p>You can use this code to reset your password: " + randomCode + ".</p>"+

	'<body style="background-color: #fafafa;display: flex;justify-content: center;align-items: center;">'+
			'<style>'+

'$font-title: "Open Sans";'+

'@import url("https://fonts.googleapis.com/css?family=Open+Sans");'+

'* {box-sizing: border-box;}'+
'body {background-color: #fafafa;display: flex;justify-content: center;align-items: center;}'+
'.c-email {width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);'+
'&__header {background-color: #0fd59f;width: 100%;height: 60px;'+
    '&__title {font-size: 23px;font-family: $font-title;height: 60px;line-height: 60px;margin: 0;text-align: center;color: white;}}'+
 ' &__content {width: 100%;height: 300px;display: flex;flex-direction: column;justify-content: space-around;align-items: center;flex-wrap: wrap;background-color: #fff;padding: 15px;'+
'    &__text {font-size: 20px;text-align: center;color: #343434;margin-top: 0;}}'+
 ' &__code {display: block;width: 60%;margin: 30px auto;background-color: #ddd;border-radius: 40px;padding: 20px;text-align: center;font-size: 36px;font-family: $font-title;letter-spacing: 10px;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);}'+
'  &__footer {width: 100%;height: 60px;background-color: #fff;}}'+

'.text-title {font-family: $font-title;}'+
'.text-center {text-align: center;}'+
'.text-italic {font-style: italic;}'+
'.opacity-30 {opacity: 0.3;}'+
'.mb-0 {margin-bottom: 0;}'+



		'</style>'+
		'<div style="width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);">' +
  '<div style="width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);background-color: #0fd59f;width: 100%;height: 60px;">'+
    '<h1 style="width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);background-color: #0fd59f;width: 100%;height: 60px;font-size: 23px;font-family: $font-title;height: 60px;line-height: 60px;margin: 0;text-align: center;color: white;">Your Verification Code</h1>'+
  '</div>'+
  '<div style="width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);width: 100%;height: 300px;display: flex;flex-direction: column;justify-content: space-around;align-items: center;flex-wrap: wrap;background-color: #fff;padding: 15px;">'+
    '<p style="width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);width: 100%;height: 300px;display: flex;flex-direction: column;justify-content: space-around;align-items: center;flex-wrap: wrap;background-color: #fff;padding: 15px;font-size: 20px;text-align: center;color: #343434;margin-top: 0;font-family: $font-title;">'+
      'Enter this verification code in field:'+
    '</p>'+
    '<div style="width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);display: block;width: 60%;margin: 30px auto;background-color: #ddd;border-radius: 40px;padding: 20px;text-align: center;font-size: 36px;font-family: $font-title;letter-spacing: 10px;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);">'+
      '<span style="width: 40vw;border-radius: 40px;overflow: hidden;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);display: block;width: 60%;margin: 30px auto;background-color: #ddd;border-radius: 40px;padding: 20px;text-align: center;font-size: 36px;font-family: $font-title;letter-spacing: 10px;box-shadow: 0px 7px 22px 0px rgba(0, 0, 0, 0.1);">123456</span>'+
    '</div>'+
   
  '</div>'+
  '<div style="c-email__footer"></div>'+
'</div>'+
'</body>'
	};
	transporter.sendMail(mailOptions, function (error, info) {
		if (error) {
			console.log(error);
		}
		else {
			console.log('Email sent: ' + info.response);
			con.query("INSERT INTO verificationcodes (idAuto, Verifcode) VALUES(?, ?)", [idAuto, randomCode]);
		}
	});
}
function sendForgotPasswordEmailAgencies(email, idAnnonceur) {
	let randomCode = randomize('0', 5);
	var mailOptions = {
		from: 'WeAdvert.app.contact@gmail.com',
		to: email,
		subject: 'Reset your password',
		html: "<p>You can use this code to reset your password: " + randomCode + ".</p>"
	};
	transporter.sendMail(mailOptions, function (error, info) {
		if (error) {
			console.log(error);
		}
		else {
			console.log('Email sent: ' + info.response);
			con.query("INSERT INTO verificationcodesann (idAnnonceur, VerifCode) VALUES(?, ?)", [idAnnonceur, randomCode]);
		}
	});
}

function sendPasswordChangedEmail(email, idAuto) {

	var mailOptions = {
		from: 'wecamp.app.contact@gmail.com',
		to: email,
		subject: 'Password Changed',
		html: "<p>Your password has been changed successfully: .</p>"
	};
	transporter.sendMail(mailOptions, function (error, info) {
		if (error) {
			console.log(error);
		}
		else {
			console.log('Email sent: ' + info.response);
		}
	});
}
function sendPasswordChangedEmailAgencies(email, idAnnonceur) {

	var mailOptions = {
		from: 'wecamp.app.contact@gmail.com',
		to: email,
		subject: 'Password Changed',
		html: "<p>Your password has been changed successfully: .</p>"
	};
	transporter.sendMail(mailOptions, function (error, info) {
		if (error) {
			console.log(error);
		}
		else {
			console.log('Email sent: ' + info.response);
		}
	});
}

function verifyUser(idMembre, code, cb) {
	con.query("SELECT * FROM verificationcodes WHERE idMembre = ? AND verifCode = ?", [idMembre, code],
		function (err, result) {
			if (err) throw err;
			cb(result);
		}
	);
}

function verifResetCode(idMembre, code, cb) {
	con.query("SELECT * FROM verificationcodes WHERE idMembre = ? AND verifCode = ?", [idMembre, code],
		function (err, result) {
			if (err) throw err;
			cb(result);
		}
	);
	return true;
}

// when member click on fogot my password
app.post("/forgot_password", function (req, res) {
	let email = req.body.email;
	con.query("SELECT * FROM automobiliste WHERE email = ? ", [email],
		function (err, result) {
			if (err) throw err;
			let numRows = result.length;
			console.log(result);
			if (numRows == 0) {
				res.status(401).json("Invalid Email");
			}
			else {
				sendForgotPasswordEmail(email, result[0].idAuto);
				console.log("check your email");
				res.json(result[0].idAuto);
			}
		});
});
app.post("/forgot_password_Agencies", function (req, res) {
	let email = req.body.email;
	con.query("SELECT * FROM annonceur WHERE email = ? ", [email],
		function (err, result) {
			if (err) throw err;
			let numRows = result.length;
			if (numRows = 0) {
				res.json("Invalid Email");
			}
			else {
				sendForgotPasswordEmailAgencies(email, result[0].idAnnonceur);
				console.log("check your email");
				res.json(result[0].idAnnonceur);
			}
		});
});

// used to verif the code sent
app.post("/verify_reset_code", function (req, res) {
	let email = req.body.email;
	let code = req.body.code;
	con.query("SELECT * FROM membre WHERE email = ? ", [email],
		function (err, result) {
			if (err) throw err;
			let numRows = result.length;
			if (numRows = 0) {
				res.json("Invalid Email");
			}
			else {
				var user = result[0].idMembre;
				verifResetCode(user, code, function (result) {
					let length = result.length;
					if (length == 0) {
						res.json(false);
					}
					else {
						res.json(true);
					}
				});
			}

		});

});

// when the code sent is valid
app.post("/reset_password", function (req, res) {
	let verifCode = req.body.code;
	let email = req.body.email;
	let password = req.body.password;
	con.query("SELECT * FROM automobiliste WHERE email = ? ", [email],
		function (err, resultSelect) {
			if (err) throw err;
			let numRows = resultSelect.length;
			if (numRows = 0) {
				res.json("Invalid Email");
			}
			else {
				var idAuto = resultSelect[0].idAuto;
				bcrypt.genSalt(saltRounds, function (err, salt) {
					bcrypt.hash(password, saltRounds, function (hashErr, hash) {
						con.query("UPDATE automobiliste SET password = ? WHERE idAuto = ? ", [hash, idAuto],
							function (err, result) {
								if (err) throw err;
								let numRows = result.length;
								if (numRows = 0) {
									res.json("Invalid Email");
								}
								else {
									sendPasswordChangedEmail(email, idAuto);
									con.query("DELETE FROM verificationcodes WHERE idAuto = ?", [idAuto]);
									console.log("check your email");
									res.json([idAuto]);
								}
							});
					});
				});

			}
		});

});
app.post("/reset_password_Agencies", function (req, res) {
	let verifCode = req.body.code;
	let email = req.body.email;
	let password = req.body.password;
	con.query("SELECT * FROM annonceur WHERE email = ? ", [email],
		function (err, resultSelect) {
			if (err) throw err;
			let numRows = resultSelect.length;
			if (numRows = 0) {
				res.json("Invalid Email");
			}
			else {
				var idAnnonceur = resultSelect[0].idAnnonceur;
				bcrypt.genSalt(saltRounds, function (err, salt) {
					bcrypt.hash(password, saltRounds, function (hashErr, hash) {
						con.query("UPDATE annonceur SET password = ? WHERE idAnnonceur = ? ", [hash, idAnnonceur],
							function (err, result) {
								if (err) throw err;
								let numRows = result.length;
								if (numRows = 0) {
									res.json("Invalid Email");
								}
								else {
									sendPasswordChangedEmailAgencies(email, idAnnonceur);
									con.query("DELETE FROM verificationcodesann WHERE idAnnonceur = ?", [idAnnonceur]);
									console.log("check your email");
									res.json([idAnnonceur]);
								}
							});
					});
				});

			}
		});

});

app.post("/register_user", function (req, res) {
	console.log("registering");
	let nom = req.body.nom;
	let prenom = req.body.prenom;
	let email = req.body.email;
	var plaint_password = req.body.password;
	var hash_data = saltHashPassword(plaint_password);
	var password = hash_data.passwordHash;
	var salt = hash_data.salt;
	var uid = uuid.v4();
	let dateNaiss = req.body.dateNaiss;
	let cin = req.body.cin;
	let photo = req.body.photo;
	let profession = req.body.profession;
	let lieuCirculation = req.body.lieuCirculation;
	let revenu = req.body.revenu;
	let score = req.body.score;
	let randomCode = randomize('0', 4);
	con.query("SELECT * FROM automobiliste WHERE email = ? ", [email],
		function (err, result) {
			if (err) throw err;
			let numRows = result.length;
			if (numRows != 0) {
				res.json("Email is already associated with an account");
			}
			else {
				con.query('INSERT INTO `utilisateur`(`unique_id` , `email`, `encrypted_password`, `salt`, `created_at`, `updated_at`, `nbrdefois`,`etat`,`verification_code`,`role`) ' +
					'VALUES (?,?,?,?,NOW(),NOW(),0,0,?,0)', [uid, email, password, salt, randomCode],
					function (err2, result2) {
						if (err2) throw err2;
						let resultId = result2.insertId;
						//sendVerificationEmail(email, resultId);
						con.query("INSERT INTO automobiliste (nom, prenom, email,dateNaiss,cin,photo,profession,lieuCirculation,revenu,score) VALUES(?,?,?,?,?,?,?,?,0,0)",
									[nom, prenom, email, dateNaiss, cin, photo, profession, lieuCirculation, revenu, score],
							function (err2, result2) {
								if (err2) throw err2;
								let resultId = result2.insertId;
								//sendVerificationEmail(email, resultId);
							});
						res.json(resultId);
					});

			}
		});
});
var genRandomString = function (length) {
	return crypto.randomBytes(Math.ceil(length / 2))
		.toString('hex') //Convert to hexa format
		.slice(0, length);

};
var sha512 = function (password, salt) {
	var hash = crypto.createHmac('sha512', salt); //Use SHA512
	hash.update(password);
	var value = hash.digest('hex');
	return {
		salt: salt,
		passwordHash: value
	};

};
function saltHashPassword(userPassword) {
	var salt = genRandomString(16); //Gen Random string with 16 charachters
	var passwordData = sha512(userPassword, salt);
	return passwordData;

}
app.post("/register_agencies", function (req, res) {
	console.log("registering");
	let entreprise = req.body.entreprise;
	let email = req.body.email;
	var plaint_password = req.body.password;
	var hash_data = saltHashPassword(plaint_password);
	var password = hash_data.passwordHash;
	var salt = hash_data.salt;
	let photo = req.body.photo;
	var uid = uuid.v4();
	let randomCode = randomize('0', 4);
	con.query("SELECT * FROM annonceur WHERE email = ? ", [email],
		function (err, result) {
			if (err) throw err;
			let numRows = result.length;
			if (numRows != 0) {
				res.json("Email is already associated with an account");
			}
			else {
				con.query('INSERT INTO `utilisateur`(`unique_id` , `email`, `encrypted_password`, `salt`, `created_at`, `updated_at`, `nbrdefois`,`etat`,`verification_code`,`role`) ' +
					'VALUES (?,?,?,?,NOW(),NOW(),0,0,?,0)', [uid, email, password, salt, randomCode],
					function (err2, result2) {
						if (err2) throw err2;
						let resultId = result2.insertId;
						//sendVerificationEmail(email, resultId);
						con.query("INSERT INTO annonceur (entreprise, email,image,etatValidation) VALUES(?,?,?,1)",
							[entreprise, email, photo],
							function (err2, result2) {
								if (err2) throw err2;
								let resultId = result2.insertId;
								//sendVerificationEmail(email, resultId);
							});
						res.json(resultId);
					});


			}
		});
});

let secret = 'some_secret';
app.post('/login', function (req, res) {
	let email = req.body.email;
	let password = req.body.password;
	console.log("Trying to find " + email + " with password: " + password);
	con.query("SELECT * FROM utilisateur u, automobiliste a where u.email=? and STRCMP (u.email,a.email) = 0 and u.role = 0 ", [email],
		function (err, result) {
			console.log("dfdfdfdfffffffffff");
			if (err) throw err;
			let numRows = result.length;
			console.log(result);
			if (numRows == 0) {
				res.status(401).json("Account not found");
			}
			else {
				var salt = result[0].salt;
				let token = jwt.sign({ "email": email, "password": password }, secret, { expiresIn: "15d" });
				var encrypted_password = result[0].encrypted_password;

				var hashed_password = checkHashPassword(password, salt).passwordHash;
				if (encrypted_password == hashed_password) {
					con.query("UPDATE utilisateur SET nbrdefois = 0 WHERE email = ?", [email]);
					res.status(200).send({ auth: true, token: token });

				}
				else {
					res.status(400).send();
				}
			}
		});
});
function checkHashPassword(userPassword, salt) {
	var passwordData = sha512(userPassword, salt);
	return passwordData;

}
app.post('/loginagencies', function (req, res) {
	let email = req.body.email;
	let password = req.body.password;
	//const Id = req.idAnnonceur;
	console.log("Trying to find " + email + " with password: " + password);
	con.query("SELECT * FROM utilisateur u , annonceur a WHERE u.email = ? and STRCMP (u.email,a.email) = 0 and u.role = 1  LIMIT 1", [email],
		function (err, result) {
			console.log("dfdfdfdfffffffffff");
			if (err) throw err;
			let numRows = result.length;
			console.log(result);
			if (numRows == 0) {
				res.status(401).json("Account not found");
			}
			else {
				var salt = result[0].salt;
				let token = jwt.sign({ "email": email, "password": password }, secret, { expiresIn: "15d" });
				var encrypted_password = result[0].encrypted_password;

				var hashed_password = checkHashPassword(password, salt).passwordHash;
				if (encrypted_password == hashed_password) {
					con.query("UPDATE utilisateur SET nbrdefois = 0 WHERE email = ?", [email]);
					res.status(200).send({ auth: true, token: token });

				}
				else {
					res.status(400).send();
				}
			}
		})
});

app.get('/profil-agencies', function (req, res) {
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;
				/* let numRows = result2.length;
				console.log(result2);
				console.log("rdddddd"); */

				/* if (numRows != 0)
				{
					res.json("Email or phone are already associated with an account");
				} */
				/* else
				{ */
				res.json(result2);
				console.log(result2)
				/* } */
			});


	});
});
app.get('/stat', function (req, res) {
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAnnonceur;
		con.query('SELECT FLOOR((MONTH(dateDeb))/3)+1 semester , COUNT(*) valeur FROM offre where idAnnonceur = ? GROUP BY FLOOR((MONTH(dateDeb))/3)', [hjjkbj], function (error, results, fields) {
		if (error) throw error;
		return res.send(results);
	});
  });
});
});
app.get('/offre', function (req, res) {
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAnnonceur;
				console.log("lnknknjknjknkjnk");
				console.log(hjjkbj);
				console.log(result2);
				console.log('3asb&ahjjk', hjjkbj);
				setTimeout(() => {
					con.query("SELECT * FROM offre WHERE idAnnonceur = ?", [hjjkbj],
						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");
							res.json(result3);

							console.log(result3);

						});
				}, 2000)
				/* } */
			});
	});



});
app.get('/drivers-positions', function (req, res) {
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAnnonceur;
				console.log("lnknknjknjknkjnk");
				console.log(hjjkbj);
				console.log(result2);
				console.log('3asb&ahjjk', hjjkbj);
				setTimeout(() => {
					con.query(`SELECT * FROM annonceur an, offre o, automobiliste a, revenu r, users_location ul 
					WHERE an.idAnnonceur =? AND o.idAnnonceur =? AND an.idAnnonceur = o.idAnnonceur 
					  AND o.idOffre = r.idOffre 
						AND r.idAuto = ul.idAuto AND a.idAuto = r.idAuto `, [hjjkbj,hjjkbj],
						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");
							res.json(result3);

							console.log(result3);

						});
				}, 2000)
				/* } */
			});
	});

});
app.delete('/deleteoffers/:idOffre', function (req, res) {

	var idOffre = req.params.idOffre;

	con.query("DELETE FROM offre WHERE idOffre = ?", [idOffre]);

	res.json(idOffre);
});
app.get('/countoffers', function (req, res) {
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAnnonceur;
				console.log("lnknknjknjknkjnk");
				console.log(hjjkbj);
				console.log(result2);
				console.log('3asb&ahjjk', hjjkbj);
				setTimeout(() => {
					con.query("SELECT COUNT(*) valeur FROM offre WHERE idAnnonceur = ?", [hjjkbj],
						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");
							res.json(result3);

							console.log(result3);

						});
				}, 2000)
				/* } */
			});
	});



});
app.get('/offre-auto', function (req, res) {
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM automobiliste WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAuto;
				console.log("lnknknjknjknkjnk");
				console.log(hjjkbj);
				console.log(result2);
				console.log('3asb&ahjjk', hjjkbj);
				setTimeout(() => {
					con.query("SELECT c.etatValidation,o.description,c.idoffre,o.gouvernorat,o.delegation,o.cible,o.dateDeb,o.cout,a.entreprise,a.image FROM candidature c, offre o, annonceur a WHERE c.idAuto = ? AND c.idOffre = o.idOffre AND o.idAnnonceur = a.idAnnonceur", [hjjkbj],
						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");


							console.log(result3);
							res.json(result3);
							//let gggg=result3[0].idOffre;
							//console.log("ddddffgvgff",gggg);
							//   con.query("SELECT * FROM offre WHERE idOffre IN(?,?)", ['2','3'],
							//   function (err4, result4)
							//   {  
							// 	  if (err4) throw err4;

							// 		console.log("dddddddddddddddddd");
							// 		  res.json(result4);

							// 		  console.log(result4);
							// 		});

						});
				}, 2000)
				/* } */
			});
	});



});
app.post('/verified',function(req,res)
{
	var idAuto = req.body.idAuto;

	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let idAnnonceur = result2[0].idAnnonceur;
		
				
					
		let etatvalidation = req.body.etatvalidation;
		con.query("UPDATE candidature c, offre o SET etatValidation = 1 WHERE c.idOffre=o.idOffre AND idAnnonceur =? AND idAuto= ?", [idAnnonceur,idAuto],


						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");
							res.json(result3);

							console.log(result3);

						});
			
				/* } */
			});
	});

}




);
app.get('/liste-candidature/:idOffre', function (req, res) {
	var idOffre = req.params.idOffre;
	console.log("idoffre:",idOffre);
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAnnonceur;
				
				
					con.query("SELECT aut.idAuto,aut.nom,aut.prenom,aut.dateNaiss,aut.profession,aut.lieuCirculation,aut.photo,aut.numerotelephone FROM candidature c, offre o,automobiliste aut WHERE o.idAnnonceur = ? AND o.idOffre = ? AND c.idOffre = ? AND c.idAuto=aut.idAuto", [hjjkbj,idOffre,idOffre],
						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");


							console.log(result3);
							res.json(result3);
						

						});
				
				/* } */
			});
	});



});

const http = require('http').createServer(app);
const io = require('socket.io')(http, {
  cors: {
    origins: 'http://localhost:*',
	path:'/*'
  }
});
io.on('connection',function(socket) {
	console.log('Socket: client connected');
	 socket.on("connection", function(data) {

	socket.emit('connection', data); // Updates Live Notification
	socket.broadcast.emit("connections", data);
	console.log('test',data);
    con.query("INSERT INTO `notif` (`message`,`idAuto`) VALUES ('"+data.message+"','"+data.idAuto+"')");
	
	});
	  	 socket.on("message", function(data) {

	socket.emit('message', data); // Updates Live Notification
	//socket.broadcast.emit("connections", data);
	console.log('test',data);
	socket.broadcast.emit("message", data);
    con.query("INSERT INTO `messages` (`user_from`,`user_to`,`message`,`image`,`base64`) VALUES ('"+data.user_id+"','"+data.user_to+"','"+data.message+"','"+data.image+"','"+data.base64+"')");
	
	});

  });

/* app.post('/send-notification', (req, res) => {
	
	var data={
	 message:"ddddd",
	 idAuto : 18
	}
	io.emit('notification', data); // Updates Live Notification
	con.query("INSERT INTO notif (message,idAuto) VALUES(?,?)",[data.message,data.idAuto]);

	res.send(data);
	
});
app.get('/aff-notification', (req, res) => {
	

}); */

app.get('/display-notif', function (req, res) {
		var token = req.headers['Authorization'] || req.headers['x-access-token']
		console.log(token);
		if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });
	
		jwt.verify(token, secret, function (err, decoded) {
			try {
				console.trace();
			} catch (e) {
				console.log(e)
			}
			if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });
	
	
			//res.status(200).send(decoded);
			con.query("SELECT * FROM automobiliste WHERE email = ?", [decoded.email],
				function (err2, result2) {
					if (err2) throw err2;
	
					let hjjkbj = result2[0].idAuto;
					console.log("lnknknjknjknkjnk");
					console.log(hjjkbj);
					console.log(result2);
					console.log('3asb&ahjjk', hjjkbj);
					setTimeout(() => {
						con.query("SELECT n.message FROM notif n WHERE n.idAuto = ?", [hjjkbj],
							function (err3, result3) {
								if (err3) throw err3;
	
								console.log("dddddddddddddddddd");
	
	
								console.log(result3);
								res.json(result3);
								//let gggg=result3[0].idOffre;
								//console.log("ddddffgvgff",gggg);
								//   con.query("SELECT * FROM offre WHERE idOffre IN(?,?)", ['2','3'],
								//   function (err4, result4)
								//   {  
								// 	  if (err4) throw err4;
	
								// 		console.log("dddddddddddddddddd");
								// 		  res.json(result4);
	
								// 		  console.log(result4);
								// 		});
	
							});
					}, 2000)
					/* } */
				});
		});
	
	
	
	});
app.get('/liste-candidature-images', function (req, res) {
	var idOffre = req.params.idOffre;
	console.log("idoffre:",idOffre);
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAnnonceur;
				
				
					con.query("SELECT aut.photo,aut.nom,aut.prenom FROM candidature c, offre o,automobiliste aut WHERE o.idAnnonceur = ? AND c.idOffre=o.idOffre AND c.idAuto=aut.idAuto AND c.etatValidation=1", [hjjkbj],
						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");


							console.log(result3);
							res.json(result3);
						

						});
				
				/* } */
			});
	});



});
app.get('/all-drivers', function (req, res) {
	var idOffre = req.params.idOffre;
	console.log("idoffre:",idOffre);
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM annonceur WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;

				let hjjkbj = result2[0].idAnnonceur;
				
				
					con.query("SELECT count(*) valeur FROM candidature c, offre o,automobiliste aut WHERE o.idAnnonceur = ? AND c.idOffre=o.idOffre AND c.idAuto=aut.idAuto", [hjjkbj],
						function (err3, result3) {
							if (err3) throw err3;

							console.log("dddddddddddddddddd");


							console.log(result3);
							res.json(result3);
						

						});
				
				/* } */
			});
	});



});
app.get('/profil', function (req, res) {
	var token = req.headers['Authorization'] || req.headers['x-access-token']
	console.log(token);
	if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });

	jwt.verify(token, secret, function (err, decoded) {
		try {
			console.trace();
		} catch (e) {
			console.log(e)
		}
		if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });


		//res.status(200).send(decoded);
		con.query("SELECT * FROM automobiliste WHERE email = ?", [decoded.email],
			function (err2, result2) {
				if (err2) throw err2;
				/* let numRows = result2.length;
				console.log(result2);
				console.log("rdddddd"); */

				/* if (numRows != 0)
				{
					res.json("Email or phone are already associated with an account");
				} */
				/* else
				{ */
				res.json(result2);
				console.log(result2)
				/* } */
			});


	});
});


// const storage = multer.diskStorage({
// 	destination: function (req, file, cb) {
// 	  cb(null, './images');
// 	  var fileName;
  
// 	},
// 	filename: function (req, file, cb) {
// 	  fileName=file.originalname;
// 	  cb(null, file.originalname);
// 	}
//   });
  
  
  // const fileFilter = (req, file, cb) => {
	// if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/jpg' || file.mimetype === 'image/png') {
	//   cb(null, true);
	// } else {
	//   cb(null, false)
	// }
  // };
  
  
  // const upload = multer({
	// storage: storage,
	// limits: {
	//   fileSize: 1024 * 1024 * 5
	// },
	// fileFilter: fileFilter
  // });
  
  
  app.post("/add_image", upload.single('photo'), (req, res, next) => {
	   res.send();
	   console.log(req.file);
	}, (error, req, res, next) => {
		res.status(400).send({error: error.message})
  });
  
  app.get('/file/:fileName', function (req, res) {
	  var options = {
	  root: path.join(__dirname, 'images'),
	  dotfiles: 'deny',
	  headers: {
		'x-timestamp': Date.now(),
		'x-sent': true
	  }
	}
  
	var fileName = req.params.fileName
	res.sendFile(fileName, options, function (err) {
	  if (err) {
		//res.json("pas d'image")
	  } else {
		console.log('Sent:', fileName)
	  }
	})
  });



require("./app/routes/automobiliste.routes.js")(app);
require("./app/routes/voiture.routes.js")(app);
require("./app/routes/image.routes.js")(app);
require("./app/routes/offre.routes.js")(app);
require("./app/routes/users_location.routes.js")(app);
require("./app/routes/followers.routes.js")(app);
