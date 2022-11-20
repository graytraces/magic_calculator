const functions = require("firebase-functions");
const app = require("express")();
const cors = require("cors");

const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

app.use(cors());

exports.api = functions.region("asia-northeast3").https.onRequest(app);

app.post("/check_key", (req, res) => {
  if (req.body.key.trim() === "") {
    return res.status(400).json({ comment: "필수정보가 없습니다." });
  }

  let authKeyObject = req.body;

  let firestorAuthKeyDocu = db.doc(`/auth_keys/${authKeyObject.key}`);

  firestorAuthKeyDocu
    .get()
    .then((authKeyDocuContent) => {
      if (!authKeyDocuContent.exists) {
        return res.status(404).json({ error: "인증키를 찾을 수 없습니다." });
      }

      let authKeyData = authKeyDocuContent.data();

      if (authKeyData.deviceId != undefined && authKeyData.deviceId != authKeyObject.deviceId) {
        return res
          .status(409)
          .json({
            error: "이미 " + authKeyData.deviceModel + "에서 사용중입니다.\nblahblah@blah.com으로 문의주세요",
          });
      }

      return firestorAuthKeyDocu.update({
        authDate: new Date().toISOString(),
        deviceId: authKeyObject.deviceId,
        deviceModel : authKeyObject.deviceModel
      });
    })
    .then(() => {
      return res.json({ authKeyObject });
    });
});
