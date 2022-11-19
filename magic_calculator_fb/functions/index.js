const functions = require("firebase-functions");
const app = require("express")();
const cors = require('cors');

const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();


app.use(cors());

exports.api = functions.region("asia-northeast3").https.onRequest(app);

app.get("/test", (req, res) => {
   return res.status(200).json({body : "ok"})
});

app.get("/test2/:testId", (req, res) => {
    console.log(req.params.testId);

    const newData = {
        asd:req.params.testId
    };
    db.collection("test").add(newData).then((doc) => {
        res.json(doc.id);
      })
      .catch((err) => {
        res.status(500).json({ error: "somthing went wrong" });
        console.error(err);
      });
 });
 

 app.post("/check_key", (req, res) => {

    if (req.body.key.trim() === "") {
      return res.status(400).json({ comment: "필수정보가 없습니다." });
    }

    let authKeys = req.body;


    let firestorAuthKeyDocu = db.doc(`/auth_keys/${authKeys.key}`);

    firestorAuthKeyDocu.get()
    .then((authKeyDocuContent) => {
      if (!authKeyDocuContent.exists) {
        return res.status(404).json({ error: "인증키를 찾을 수 없습니다." });
      }


      let authKeyData = authKeyDocuContent.data();

      if(authKeyData.deviceId != null){
        return res.status(409).json({ error: "이미 사용중입니다." });
      }

      return firestorAuthKeyDocu.update({
        authDate : new Date().toISOString(),
        deviceId : "test"
      })

    }).then(()=>{
        return res.json({authKeys})
    })
 });