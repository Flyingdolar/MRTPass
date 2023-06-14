<template>
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div flex="~" m="t-auto b-10px x-6" justify="items-center">
      <n-button @click="goback" quaternary>
        <n-icon :size="20"><back /></n-icon>
      </n-button>
      <div
        flex="grow"
        mt="1"
        text="title center bottom"
        style="font-size: 16px"
      >
        {{ CurrentCommon?.info.name }}
      </div>
      <n-button @click="tmp" quaternary>
        <n-icon :size="20" opacity="0"><search /></n-icon>
      </n-button>
    </div>
    <div p="y-1pt" bg=" gray-200" />
  </div>
  <div flex="~ col gap-3" h="146" overflow="auto">
    <!-- Common Information -->
    <n-card
      header-style="padding: 0;"
      footer-style="padding: 0;"
      :bordered="false"
    >
      <div
        v-if="getImage(CurrentCommon?.info.photo) != null"
        flex="~"
        justify="center"
      >
        <img w="full" m="b-4" :src="getImage(CurrentCommon?.info.photo)" />
      </div>
      <div p="y-2" text="s" style="white-space: pre-line">
        {{ CurrentCommon?.info.Des }}
      </div>
      <div p="y-2" text="xs secondary">
        地點： {{ CurrentCommon?.info.address }}
      </div>
      <template #footer>
        <div text="sm secondary">
          <div flex="~" p="x-6 b-4" v-if="CurrentCommon?.average_score">
            {{ parseFloat(CurrentCommon?.average_score).toFixed(1) }}顆星評價 ·
            {{ CurrentComment?.length }}則評論
          </div>
          <div v-else>暫無評論</div>
        </div>
      </template>
    </n-card>
    <!-- Comment -->
    <div v-for="(item, index) in CurrentComment" :key="item.comment.id">
      <n-card
        :footer-style="{ padding: '0' }"
        justify="center"
        class="content2"
      >
        <template #header>
          <div flex="~ gap-2" justify="items-center">
            <n-icon :size="20" my="auto"><user /></n-icon>
            <div text="sm">{{ item.name }}</div>
          </div>
        </template>
        <template #header-extra>
          <div flex="~ gap-2px" w="30">
            <div text="xs secondary" my="auto">評分：</div>
            <div v-for="index in item.comment.score" :key="index">
              <n-icon text="yellow">
                <star />
              </n-icon>
            </div>
          </div>
        </template>
        <div
          flex="~"
          justify="center"
          v-if="getImage(item.comment.photo) != null"
        >
          <n-image
            width="280"
            border="rounded-lg"
            m="b-4"
            :src="getImage(item.comment.photo)"
          />
        </div>
        <div text="base body" style="white-space: pre-line">
          {{ item.comment.comment }}
        </div>
        <template #footer>
          <div text="xs secondary" m="x-6 y-4">
            {{ itemDate(item.comment.created_at, item.comment.updated_at) }}
          </div>
          <div flex="~" justify="center items-center" p="x-4 y-2">
            <n-button
              @click="showEditModal(item.comment.id, index)"
              v-if="SameUser(item.comment.member_id)"
              flex="~ grow"
              size="medium"
              type="info"
              quaternary
            >
              <template #icon>
                <n-icon :size="18"><edit /></n-icon>
              </template>
              <div>編輯</div>
            </n-button>
            <div
              v-if="SameUser(item.comment.member_id)"
              m="1"
              p="0.8px"
              bg="gray-200"
            />
            <n-button
              v-if="SameUser(item.comment.member_id) || isAdmin"
              @click="DeleteCommentShow(item.comment.id, index)"
              flex="~ grow"
              size="medium"
              type="error"
              quaternary
            >
              <template #icon>
                <n-icon :size="18"><remove /></n-icon>
              </template>
              <div>刪除</div>
            </n-button>
          </div>
        </template>
      </n-card>
    </div>
    <div p="5" />
  </div>

  <!-- Card: New Credit -->
  <n-card pos="fixed bottom-16" footer-style="padding: 0px;" :hoverable="true">
    <template #footer>
      <div class="flex justify-center py-4 px-12">
        <n-button flex="~ grow" type="success" ghost @click="showCreditModal">
          <template #icon>
            <n-icon :size="18"><add /></n-icon>
          </template>
          新增評論
        </n-button>
      </div>
    </template>
  </n-card>

  <!-- Credit Modal -->
  <n-modal v-model:show="CreditModalShow">
    <n-card
      title="給予評論"
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
          <n-form-item label="評論" path="context">
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
  <!-- Overlay: Edit Comment -->
  <n-modal v-model:show="EditCommentModal">
    <n-card
      title="變更評論"
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
          <n-form-item label="評論" path="context">
            <template #header-extra> 必填 </template>
            <n-input
              v-model:value="model.editedcontent"
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
            <n-rate size="large" v-model:value="model.editedrate" />
          </n-form-item>
        </n-form>
      </n-space>
      <template #footer>
        <n-button @click="editUserComment">送出</n-button>
      </template>
    </n-card>
  </n-modal>
  <!-- Overlay: Confirm Delete -->
  <n-modal v-model:show="DeleteCommentModal">
    <n-card
      w="3/4 min-30"
      title="確定要刪除？"
      :header-style="{ 'align-self': 'center' }"
    >
      <div text="sm center secondary" pb="2">請注意，刪除後無法復原</div>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-2">
          <n-button type="error" flex="grow" ghost @click="deleteUserComment">
            <template #icon>
              <n-icon :size="18"><remove /></n-icon>
            </template>
            <div>刪除</div>
          </n-button>
          <n-button
            @click="showDelete = false"
            type="tertiary"
            flex="grow"
            ghost
          >
            <template #icon>
              <n-icon :size="18"><cancel /></n-icon>
            </template>
            <div>取消</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </n-modal>
</template>

<script setup lang="ts">
import {
  NCard,
  NSpace,
  NButton,
  NModal,
  useMessage,
  NRate,
  NForm,
  NInput,
  NIcon,
  NImage,
  NFormItem,
  FormRules,
  FormItemRule,
} from "naive-ui";
import back from "../assets/icon/iExpLeft.vue";
import star from "../assets/icon/iStar.vue";
import add from "../assets/icon/iAdd.vue";
import edit from "../assets/icon/iEdit.vue";
import user from "../assets/icon/iUser.vue";
import remove from "../assets/icon/iTrash.vue";
import search from "../assets/icon/iSearch.vue";
import cancel from "../assets/icon/iRefund.vue";
import { computed, onMounted, ref, reactive } from "vue";
import { Common, CommentAPI } from "../scripts/types";
import axios from "axios";
import router from "@/router";
import store from "@/scripts/vuex";
import { useRoute } from "vue-router";

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
  editedcontent: "",
  editedrate: "",
});
const Userid = computed(() => {
  return store.state?.userinfo?.id;
});
const isAdmin = computed(() => {
  if ((store.state?.userinfo?.role as unknown as string) == "admin") {
    return true;
  } else if (
    (store.state?.userinfo?.role as unknown as string) == "mrt_admin"
  ) {
    return true;
  } else {
    return false;
  }
});
function SameUser(id: number) {
  if (Userid.value == id) {
    return true;
  } else {
    return false;
  }
}
function reloadCommon() {
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
  //axios
}
function reloadComment() {
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
}

onMounted(() => {
  reloadCommon();
  reloadComment();
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

function getImage(photo: any) {
  if (photo == null) return null;
  if (photo.url == null) return null;
  return "http://localhost:3000" + photo.url;
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
const EditCommentModal = ref(false);
const EditCommentID = ref(0);
const EditCommentIndex = ref(0);
function showEditModal(id: number, index: number) {
  EditCommentModal.value = true;
  model.editedcontent = CurrentComment.value[index].comment.comment;
  model.editedrate = CurrentComment.value[index].comment.score;
  EditCommentID.value = id;
  EditCommentIndex.value = index;
}
function editUserComment() {
  const rate = ref<number>(parseInt(model.editedrate));
  formData.append("comment", model.editedcontent);
  formData.append("score", rate.value);
  //axios patch
  axios
    .patch(
      "http://localhost:3000/api/member/info/" +
        route.params.id +
        "/comment/" +
        EditCommentID.value.toString(),
      formData
    )
    .then(function (response) {
      console.log(response);
      //router.go(0);
      EditCommentModal.value = false;
      reloadCommon();
      reloadComment();
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
const DeleteCommentModal = ref(false);
const DeleteCommentID = ref(0);
const DeleteCommentIndex = ref(0);
function DeleteCommentShow(id: number, index: number) {
  DeleteCommentModal.value = true;
  DeleteCommentID.value = id;
  DeleteCommentIndex.value = index;
}
function deleteUserComment() {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/member/info/" +
        route.params.id +
        "/comment/" +
        DeleteCommentID.value.toString()
    )
    .then(function (response) {
      console.log(response);
      reloadCommon();
      reloadComment();
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
