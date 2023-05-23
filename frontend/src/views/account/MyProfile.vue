<!-- eslint-disable prettier/prettier -->
<template>
  <n-card>
    <n-card>
      <span>{{ Username }}</span
      ><br />
      <span>{{ Userrole }}</span>
    </n-card>
    <n-list>
      <template #header> 個人資料 </template>
      <n-list-item>
        <n-space vertical>
          <n-button @click="editUserNamemodal = true">修改使用者名稱</n-button
          ><br />
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
          <n-button @click="editPhotomodal = true">修改頭像照片</n-button><br />
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
                multiple
                directory-dnd
                action="https://www.mocky.io/v2/5e4bafc63100007100d8b70f"
                :max="5"
              >
                <n-upload-dragger>
                  <div style="margin-bottom: 12px">
                    <n-icon size="48" :depth="3">
                      <archive-icon />
                    </n-icon>
                  </div>
                  <n-text style="font-size: 16px">
                    點擊或拖移以上傳照片
                  </n-text>
                  <n-p depth="3" style="margin: 8px 0 0 0"> 這邊先隨便:D </n-p>
                </n-upload-dragger>
              </n-upload>
              <template #footer>
                <n-space justify="center">
                  <n-button @click="editUserName">儲存</n-button>
                  <n-button @click="editUserNamemodal = false">取消</n-button>
                </n-space>
              </template>
            </n-card>
          </n-modal>
          <n-button @click="editPasswordmodal = true">修改密碼</n-button><br />
          <n-modal v-model:show="editPasswordmodal">
            <n-card
              style="width: 600px"
              title="修改密碼"
              :bordered="false"
              size="huge"
              role="dialog"
              aria-modal="true"
            >
              <n-form ref="formRef" :label-width="80">
                <n-form-item label="舊密碼">
                  <n-input
                    type="password"
                    show-password-on="click"
                    placeholder="請輸入舊密碼"
                    v-model:value="model.oldPassword"
                  />
                </n-form-item>
                <n-form-item label="新密碼">
                  <n-input
                    type="password"
                    show-password-on="click"
                    placeholder="請輸入新密碼"
                    v-model:value="model.newPassword"
                  />
                </n-form-item>
                <n-form-item label="確認新密碼">
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
    <n-list v-if="roleisAdmin">
      <template #header> 管理 </template>
      <n-list-item>
        <n-space vertical>
          <n-button @click="editAllUser">使用者權限</n-button><br />
          <n-button @click="editMRT">捷運資訊調整</n-button><br />
        </n-space>
      </n-list-item>
    </n-list>
  </n-card>
  <n-space justify="center">
    <n-button @click="logout">登出</n-button>
  </n-space>
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
} from "naive-ui";
import { ref, reactive, computed, onMounted } from "vue";
import store from "/src/scripts/vuex.ts";
import { watchOnce } from "@vueuse/core";

const roleisAdmin = ref(false);
const editUserNamemodal = ref(false);
const editPhotomodal = ref(false);
const editPasswordmodal = ref(false);
const Username = computed(() => {
  return store.state?.userinfo?.data.nickname;
});
const Userrole = computed(() => {
  if ((store.state?.userinfo?.data.role as string) == "admin") {
    return "系統管理員";
  } else if ((store.state?.userinfo?.data.role as string) == "mrt_admin") {
    return "捷運管理員";
  } else {
    return "一般會員";
  }
});

onMounted(() => {
  roleisAdmin.value = true;
  if ((store.state.userinfo.role as string) == "admin") {
    roleisAdmin.value = true;
  }
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
      console.log(response);
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
  //axios post
  axios
    .patch("http://localhost:3000/update", {
      nickname: model.newName,
      picture: null,
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
  //axios post
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
  router.push("/");
}
function editMRT() {
  router.push("/");
}
</script>
