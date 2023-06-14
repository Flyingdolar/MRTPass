<template>
  <div flex="~ col gap-3" m="y-3">
    <div
      flex="~ gap-6"
      justify="items-center"
      p="x-6 y-4"
      bg="white"
      :class="roleColor"
      border="t-3 b-3 opacity-10"
    >
      <n-icon size="48"><userIcon /></n-icon>
      <div flex="~ col gap-2">
        <div text="base title" font="500">{{ Username }}</div>
        <div text="xs secondary">{{ Userrole }}</div>
      </div>
    </div>
    <n-list>
      <template #header>
        <div m="l-6" text="title lg">個人資料</div>
      </template>
      <n-list-item>
        <n-space vertical align="center">
          <n-button
            v-if="!roleisAdmin"
            @click="editUserNamemodal = true"
            quaternary
            type="primary"
          >
            修改使用者名稱
          </n-button>
          <!-- Overlay: Change user name -->
          <n-modal v-model:show="editUserNamemodal">
            <n-card
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
                  <div flex="~ gap-8" class="justify-center px-12">
                    <n-button
                      @click="editUserName"
                      type="primary"
                      flex="grow"
                      ghost
                    >
                      <template #icon>
                        <n-icon :size="18"><save /></n-icon>
                      </template>
                      <div>儲存</div>
                    </n-button>
                    <n-button
                      @click="editUserNamemodal = false"
                      type="tertiary"
                      flex="grow"
                      ghost
                    >
                      <template #icon>
                        <n-icon :size="18"><back /></n-icon>
                      </template>
                      <div>取消</div>
                    </n-button>
                  </div>
                </n-space>
              </template>
            </n-card>
          </n-modal>
          <n-button
            v-if="!roleisAdmin"
            @click="editPhotomodal = true"
            quaternary
            type="primary"
          >
            修改頭像照片
          </n-button>
          <!-- Overlay: Change Avatar -->
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
              >
                <n-upload-dragger w="full">
                  <div
                    p="x-4 y-4"
                    bg="hover:blue-100"
                    text="seconary hover:blue"
                    border="rounded-lg 1 gray-200 hover:blue-400"
                  >
                    <div flex="~" justify="center">
                      <n-icon size="48"><add /></n-icon>
                    </div>
                  </div>
                </n-upload-dragger>
              </n-upload>
              <template #footer>
                <n-space justify="center">
                  <div flex="~ gap-8" class="justify-center px-12">
                    <n-button
                      @click="saveChange"
                      type="primary"
                      flex="grow"
                      ghost
                    >
                      <template #icon>
                        <n-icon :size="18"><save /></n-icon>
                      </template>
                      <div>儲存</div>
                    </n-button>
                    <n-button
                      @click="editPhotomodal = false"
                      type="tertiary"
                      flex="grow"
                      ghost
                    >
                      <template #icon>
                        <n-icon :size="18"><back /></n-icon>
                      </template>
                      <div>取消</div>
                    </n-button>
                  </div>
                </n-space>
              </template>
            </n-card>
          </n-modal>
          <n-button @click="editPasswordmodal = true" quaternary type="primary">
            修改密碼
          </n-button>
          <!-- Overlay: Change password -->
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
                  <div flex="~ gap-8" class="justify-center px-12">
                    <n-button
                      @click="editPassword"
                      type="primary"
                      flex="grow"
                      ghost
                    >
                      <template #icon>
                        <n-icon :size="18"><save /></n-icon>
                      </template>
                      <div>儲存</div>
                    </n-button>
                    <n-button
                      @click="editPasswordmodal = false"
                      type="tertiary"
                      flex="grow"
                      ghost
                    >
                      <template #icon>
                        <n-icon :size="18"><back /></n-icon>
                      </template>
                      <div>取消</div>
                    </n-button>
                  </div>
                </n-space>
              </template>
            </n-card>
          </n-modal>
        </n-space>
      </n-list-item>
    </n-list>
    <n-list v-if="roleisAdmin">
      <template #header> <div m="l-6" text="title lg">管理</div></template>
      <n-list-item>
        <n-space vertical align="center">
          <n-button quaternary type="primary" @click="editAllUser">
            使用者權限
          </n-button>
          <n-button quaternary type="primary" @click="editMRTLine">
            捷運路線設定
          </n-button>
          <n-button quaternary type="primary" @click="editTicketPrice">
            票價距離設定
          </n-button>
          <n-button quaternary type="primary" @click="editMRTStation">
            捷運站點設定
          </n-button>
        </n-space>
      </n-list-item>
    </n-list>
    <n-space justify="center" bg="white" py="2">
      <n-button @click="logout" type="error" quaternary>
        <template #icon>
          <n-icon :size="18"><signout /></n-icon>
        </template>
        <div>登出</div>
      </n-button>
    </n-space>
  </div>
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
import store from "/src/scripts/vuex.ts";
import { watchOnce } from "@vueuse/core";
import { useMessage } from "naive-ui";
import signout from "../../assets/icon/iSignout.vue";
import userIcon from "../../assets/icon/iUser.vue";
import save from "../../assets/icon/iSave.vue";
import back from "../../assets/icon/iRefund.vue";
import add from "../../assets/icon/iAdd.vue";

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
const message = useMessage();
const Username = computed(() => {
  return store.state?.userinfo?.nickname;
});
const Userrole = computed(() => {
  if ((store.state?.userinfo?.role as unknown as string) == "admin") {
    return "系統管理員";
  } else if (
    (store.state?.userinfo?.role as unknown as string) == "mrt_admin"
  ) {
    return "捷運管理員";
  } else {
    return "一般會員";
  }
});
const roleColor = computed(() => {
  if ((store.state?.userinfo?.role as unknown as string) == "admin") {
    return "text-red border-red";
  } else if (
    (store.state?.userinfo?.role as unknown as string) == "mrt_admin"
  ) {
    return "text-orange border-orange";
  } else {
    return "text-blue border-blue";
  }
});
const rules: FormRules = {
  oldPassword: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("Old password is required");
        } else if (value != store.state.userinfo.password) {
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
  if ((store.state.userinfo?.role as unknown as string) == "admin") {
    roleisAdmin.value = true;
  }
  // message.info(store.state.userinfo.nickname);
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
      store.dispatch("userinfo", undefined);
      router.push("/account");
    })
    .catch(function (error) {
      store.dispatch("userinfo", undefined);
      message.error(error);
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
      message.success("使用者名稱修改成功");
      store.dispatch("userinfo", response.data.data);
      editUserNamemodal.value = false;
    })
    .catch(function (error) {
      message.error("修改失敗，請檢查輸入是否正確");
    });
  //axios
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
      message.success("密碼修改成功");
      store.dispatch("userinfo", response.data.data);
      editPasswordmodal.value = false;
    })
    .catch(function (error) {
      message.error("密碼修改失敗，請檢查輸入是否正確");
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
function editTicketPrice() {
  router.push("/ticketprice");
}

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
  formData.delete("picture");
  if (event.length == 0) return;
  formData.append("picture", event[0].file, event[0].file.name);
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
      message.success("上傳圖片成功");
    })
    .catch(function (error) {
      message.error("上傳圖片失敗");
    });
}
</script>
