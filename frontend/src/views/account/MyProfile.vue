<template>
  <n-card>
    <n-card>
      <span>{{ Username }}</span
      ><br />
      <span>{{ Userrole }}</span>
    </n-card>
    <n-list align="center">
      <template #header> 個人資料 </template>
      <n-list-item>
        <n-space vertical align="center">
          <n-button v-if="!roleisAdmin" @click="editUserNamemodal = true"
            >修改使用者名稱</n-button
          >
          <n-modal v-model:show="editUserNamemodal">
            <n-card
              style="width: 600px"
              title="修改使用者名稱"
              :bordered="false"
              size="huge"
              role="dialog"
              aria-modal="true"
            >
              <n-input
                v-model:value="model.newName"
                placeholder="請輸入使用者名稱"
              />
              <template #footer>
                <n-space justify="center">
                  <n-button @click="editUserName">儲存</n-button>
                  <n-button @click="editUserNamemodal = false">取消</n-button>
                </n-space>
              </template>
            </n-card>
          </n-modal>
          <n-button v-if="!roleisAdmin" @click="editPhotomodal = true"
            >修改頭像照片</n-button
          >
          <n-modal v-model:show="editPhotomodal">
            <n-card
              style="width: 600px"
              title="修改頭像照片"
              :bordered="false"
              size="huge"
              role="dialog"
              aria-modal="true"
            >
              <n-upload
                :on-before-upload="handleImgBefore"
                :on-update-file-list="handleImgChange"
                :on-remove="handleImgRemove"
              >
                <n-button>上傳照片</n-button>
              </n-upload>
              <template #footer>
                <n-space justify="center">
                  <n-button @click="saveChange">儲存</n-button>
                  <n-button @click="editPhotomodal = false">取消</n-button>
                </n-space>
              </template>
            </n-card>
          </n-modal>
          <n-button @click="editPasswordmodal = true">修改密碼</n-button>
          <n-modal v-model:show="editPasswordmodal">
            <n-card
              style="width: 600px"
              title="修改密碼"
              :bordered="false"
              size="huge"
              role="dialog"
              aria-modal="true"
            >
              <n-form
                ref="formRef"
                :label-width="80"
                :model="model"
                :rules="rules"
              >
                <n-form-item label="舊密碼" path="oldPassword">
                  <n-input
                    type="password"
                    show-password-on="click"
                    placeholder="請輸入舊密碼"
                    v-model:value="model.oldPassword"
                  />
                </n-form-item>
                <n-form-item label="新密碼" path="newPassword">
                  <n-input
                    type="password"
                    show-password-on="click"
                    placeholder="請輸入新密碼"
                    v-model:value="model.newPassword"
                  />
                </n-form-item>
                <n-form-item label="確認新密碼" path="comfirmPassword">
                  <n-input
                    type="password"
                    show-password-on="click"
                    placeholder="請再次輸入新密碼"
                    v-model:value="model.comfirmPassword"
                  />
                </n-form-item>
              </n-form>
              <template #footer>
                <n-space justify="center">
                  <n-button @click="editPassword">儲存</n-button>
                  <n-button @click="editPasswordmodal = false">取消</n-button>
                </n-space>
              </template>
            </n-card>
          </n-modal>
        </n-space>
      </n-list-item>
    </n-list>
    <n-list v-if="roleisAdmin" align="center">
      <template #header> 管理 </template>
      <n-list-item>
        <n-space vertical align="center">
          <n-button @click="editAllUser">使用者權限</n-button>
          <n-button @click="editMRTLine">捷運路線設定</n-button>
          <n-button @click="editMRTStation">捷運站點設定</n-button>
        </n-space>
      </n-list-item>
    </n-list>
    <n-space justify="center">
      <n-button @click="logout">登出</n-button>
    </n-space>
  </n-card>
</template>

<script setup lang="ts">
import router from "@/router";
import axios from "axios";
import {
  NList,
  NListItem,
  NButton,
  NModal,
  NCard,
  NInput,
  NSpace,
  NForm,
  NFormItem,
  NUploadDragger,
  NUpload,
  NIcon,
  NText,
  NP,
  FormRules,
  FormItemRule,
} from "naive-ui";
import { ref, reactive, computed, onMounted, onBeforeMount } from "vue";
import store from "../../scripts/vuex";

const previewImage = ref<string | null>(null);
const imageFile = ref<File | null>(null);
const formData = new FormData();
let file: File | null = null;

const uploadImage = (e: Event) => {
  const target = e.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    const image = target.files[0];
    const reader = new FileReader();
    reader.readAsDataURL(image);
    reader.onload = (e) => {
      previewImage.value = e.target?.result as string;
      console.log(previewImage.value);

      // 將選擇的圖像文件存儲到 imageFile 變量中
      imageFile.value = image;
    };
  }
};
const roleisAdmin = ref(false);
const editUserNamemodal = ref(false);
const editPhotomodal = ref(false);
const editPasswordmodal = ref(false);
const Username = computed(() => {
  return store.state?.userinfo?.nickname;
});
const Userrole = computed(() => {
  if ((store.state?.userinfo?.role as string) == "admin") {
    return "系統管理員";
  } else if ((store.state?.userinfo?.role as string) == "mrt_admin") {
    return "捷運管理員";
  } else {
    return "一般會員";
  }
});
const rules: FormRules = {
  oldPassword: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("Old password is required");
        } else if (value != store.state.userinfo.data.password) {
          return new Error("Worng old password");
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
  newPassword: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("New password is required");
        } else if (value != model.comfirmPassword) {
          return new Error(
            "New password and comfirmed password should be the same"
          );
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
  comfirmPassword: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("Comfirmed password is required");
        } else if (value != model.newPassword) {
          return new Error(
            "New password and comfirmed password should be the same"
          );
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
};
onBeforeMount(() => {
  if ((store.state.userinfo.role as string) == "admin") {
    roleisAdmin.value = true;
  }
  //console.log(store.state.userinfo);
});
const model = reactive({
  newName: "",
  newphoto: "",
  oldPassword: "",
  newPassword: "",
  comfirmPassword: "",
});
function logout() {
  //axios post
  axios
    .post("http://localhost:3000/sign_out")
    .then(function (response) {
      //console.log(response);
      store.dispatch("userinfo", undefined);
      router.push("/account");
    })
    .catch(function (error) {
      store.dispatch("userinfo", undefined);
      console.log(error);
      router.push("/account");
    });
  //axios
}

function editUserName() {
  //axios patch
  axios
    .patch("http://localhost:3000/update", {
      nickname: model.newName,
    })
    .then(function (response) {
      console.log(response);
      store.dispatch("userinfo", response.data);
      editUserNamemodal.value = false;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function editPhoto() {
  editPhotomodal.value = true;
}
function editPassword() {
  //axios patch
  axios
    .patch("http://localhost:3000/password", {
      old_password: model.oldPassword,
      new_password: model.newPassword,
      confirmation: model.comfirmPassword,
    })
    .then(function (response) {
      console.log(response);
      store.dispatch("userinfo", response.data);
      editUserNamemodal.value = false;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function editAllUser() {
  router.push("/memberlist");
}
function editMRTLine() {
  router.push("/linelist");
}
function editMRTStation() {
  router.push("/stationlist");
}
// function Photopatch() {
//   //axios patch
//   if (imageFile.value) {
//     // 將圖像資料發送到後端
//     const formData = new FormData();
//     formData.append("image", imageFile.value);
//     console.log(formData.values);
//     //axios patch
//     axios
//       .patch("http://localhost:3000/update", {
//         picture: formData.values,
//       })
//       .then(function (response) {
//         console.log(response);
//       })
//       .catch(function (error) {
//         console.log(error);
//       });
//     //axios
//   }
// }

function handleImgBefore(event: any) {
  const file = event.file;
  const isImage = file.type.includes("image");
  const fileSize = file.file.size / 1024 / 1024;
  // TODO: 顯示錯誤訊息
  if (!isImage) console.error("上傳內容必須為圖片格式!");
  if (fileSize > 2) console.error("上傳圖片大小不能超過2MB!");
  return isImage && fileSize < 2;
}

function handleImgChange(event: any) {
  formData.append("picture", event[0].file, event[0].file.name);
}

function handleImgRemove() {
  formData.delete("picture");
}

function cancelChange() {
  formData.delete("picture");
}

function saveChange() {
  axios
    .patch("http://localhost:3000/update", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    })
    .then(function (response) {
      store.dispatch("userinfo", response.data);
      editPhotomodal.value = false;
    })
    .catch(function (error) {
      console.log(error);
    });
}
</script>
