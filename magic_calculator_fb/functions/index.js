const functions = require("firebase-functions");
const app = require("express")();
const cors = require("cors");

const admin = require("firebase-admin");
admin.initializeApp();

exports.addMessage = functions
  .region("asia-northeast3")
  .https.onRequest(async (req, res) => {
    res.json({ result: `Message with ID: added.` });
  });

const db = admin.firestore();

app.use(cors());

exports.api = functions.region("asia-northeast3").https.onRequest(app);

app.post("/check_key", (req, res) => {
  if (req.body.key.trim() === "") {
    return res.status(400).json({ comment: "필수정보가 없습니다." });
  }

  let authKeys = req.body;

  let firestorAuthKeyDocu = db.doc(`/auth_keys/${authKeys.key}`);

  firestorAuthKeyDocu
    .get()
    .then((authKeyDocuContent) => {
      if (!authKeyDocuContent.exists) {
        return res.status(404).json({ error: "인증키를 찾을 수 없습니다." });
      }

      let authKeyData = authKeyDocuContent.data();

      if (authKeyData.deviceId != null) {
        return res
          .status(409)
          .json({
            error: "이미 사용중입니다.\nblahblah@blah.com으로 문의주세요",
          });
      }

      return firestorAuthKeyDocu.update({
        authDate: new Date().toISOString(),
        deviceId: "test",
      });
    })
    .then(() => {
      return res.json({ authKeys });
    });
});
