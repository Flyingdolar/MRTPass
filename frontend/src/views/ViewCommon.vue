<template>
  <n-card class="card">
    <div>
      <n-space justify="space-around" size="large" line-height="20px">
        <n-button @click="goback" size="large">返回</n-button>
        <n-h3 class="cardtitle">{{ CurrentCommon?.info.name }}</n-h3>
        <n-button @click="goback" size="large">Option</n-button>
      </n-space>
    </div>
    <n-space
      :header-style="{ 'align-self': 'center' }"
      :footer-style="{ 'align-self': 'center' }"
      justify="center"
      class="content2"
    >
      <n-card
        header-style="padding: 0;"
        footer-style="padding: 0;"
        :bordered="false"
      >
        <template #default>
          <div p="y-2" text="s">{{ CurrentCommon?.info.Des }}</div>
          <div p="y-2" text="xs secondary">
            地點： {{ CurrentCommon?.info.address }}
          </div>
        </template>
        <template #footer>
          <div flex="~" p="x-4 y-2" v-if="CurrentCommon?.average_score">
            {{ parseFloat(CurrentCommon?.average_score).toFixed(1) }}顆星評價·{{
              CurrentComment?.length
            }}則評論
          </div>
          <div v-else>暫無評論</div>
        </template>
      </n-card>
    </n-space>
    <div v-for="item in CurrentComment" :key="item.comment.id">
      <n-card
        :footer-style="{ 'align-self': 'center' }"
        justify="center"
        class="content2"
        :title="item.name"
      >
        <template #header-extra> {{ item.comment.score }}顆星評價 </template>
        {{ item.comment.comment }}
        <template #footer>
          {{ itemDate(item.comment.created_at, item.comment.updated_at) }}
        </template>
      </n-card>
    </div>
    <template #footer>
      <n-space justify="center">
        <n-button @click="showCreditModal">評論</n-button>
      </n-space>
    </template>
    <n-modal v-model:show="CreditModalShow">
      <n-card
        title="給予評分"
        :header-style="{ 'align-self': 'center' }"
        :footer-style="{ 'align-self': 'center' }"
        justify="center"
      >
        <n-space justify="center">
          <n-form
            ref="formRef"
            :label-width="100"
            :model="model"
            :rules="rules"
            require-mark-placement="right-hanging"
          >
            <n-form-item label="內文" path="context">
              <template #header-extra> 必填 </template>
              <n-input
                v-model:value="model.context"
                type="textarea"
                placeholder="輸入內文"
              />
            </n-form-item>
            <n-form-item label="圖片" path="title">
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
            </n-form-item>
            <n-form-item label="評分" path="rate">
              <n-rate size="large" v-model:value="model.rate" />
            </n-form-item>
          </n-form>
        </n-space>
        <template #footer>
          <n-button @click="submitCredt">送出</n-button>
        </template>
      </n-card>
    </n-modal>
  </n-card>
</template>

<script setup lang="ts">
import {
  NCard,
  NSpace,
  NButton,
  NModal,
  NDataTable,
  useMessage,
  NH3,
  NPopconfirm,
  NRate,
  NForm,
  NInput,
  NIcon,
  NFormItem,
  FormRules,
  NDivider,
  FormItemRule,
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import { computed, h, onMounted, ref, watch, reactive } from "vue";
import { watchOnce } from "@vueuse/core";
import { Station, Role, Common, Comment, CommentAPI } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
import { useRoute } from "vue-router";
import { parentPort } from "worker_threads";
import { ca } from "date-fns/locale";
const EditUsermodal = ref(false);
const CurrentCommon = ref<Common>();
const CurrentComment = ref<CommentAPI[]>();
const route = useRoute();
const rules: FormRules = {
  rate: [
    {
      required: true,
      trigger: ["input", "blur"],
    },
  ],
  context: [
    {
      required: true,
      validator(rule: FormItemRule, value: Text) {
        if (!value) {
          return new Error("Content is required");
        }
        return true;
      },
      trigger: ["input", "blur"],
    },
  ],
};
function itemDate(create: string, update: string) {
  const date = create == update ? new Date(create) : new Date(update);
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const hour = date.getHours();
  const minute = date.getMinutes();
  if (create == update) {
    return `發佈於 ${year}.${month}.${day} ${hour}:${minute}`;
  } else {
    return `更新於 ${year}.${month}.${day} ${hour}:${minute}`;
  }
}
const model = reactive({
  context: "",
  rate: 5,
});
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/common/" + route.params.id)
    .then(function (response) {
      //console.log(response);
      CurrentCommon.value = response.data.data;
      console.log(CurrentCommon.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios 	/api/member/info/:info_id/comment/:id
  //axios get
  axios
    .get(
      "http://localhost:3000/api/member/info/" + route.params.id + "/comment"
    )
    .then(function (response) {
      console.log(response);
      CurrentComment.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
function goback() {
  router.push("/post/MRTcommon");
}
function tmp() {
  console.log("Not yet:D");
}
const CreditModalShow = ref(false);
function showCreditModal() {
  CreditModalShow.value = true;
}
const formData = new FormData();
function showImage(item) {
  if (item.photo.url != null) return "http://localhost:3000" + item.photo.url;
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
  formData.delete("photo");
  if (event.length === 0) return;
  formData.append("photo", event[0].file, event[0].file.name);
}
function submitCredt() {
  const rate = ref<number>(parseInt(model.rate));
  formData.append("comment", model.context);
  formData.append("score", rate.value);
  //axios post
  axios
    .post(
      "http://localhost:3000/api/member/info/" + route.params.id + "/comment",
      formData
    )
    .then(function (response) {
      console.log(response);
      //router.go(0);
      CurrentComment.value?.push(response.data.data);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
