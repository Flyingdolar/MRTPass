<template>
  <div flex="~ col" justify="center items-end" h="10" bg="white">
    <div m="t-auto b-10px" text="title center bottom">遺失物公告</div>
    <div p="y-1px" bg=" gray-200" />
  </div>
  <div flex="~ col" h="160" overflow="auto" w="full" gap="2">
    <!-- List Empty view -->
    <div
      v-if="isListEmpty"
      flex="~ col"
      justify="center items-center"
      m="x-4 y-2"
    >
      <div text="center">目前沒有任何遺失物喔！</div>
    </div>
    <!-- Card: Lost Items -->
    <n-card
      v-else
      v-for="item in lostList"
      :key="item.id"
      header-style="padding: 0;"
      footer-style="padding: 0;"
      :bordered="false"
    >
      <template #header>
        <div flex="~ col" justify="items-start" gap="1" m="x-4 t-3">
          <div flex="~" justify="items-end" text="xs" font="normal">
            <div :class="setAttrClass(item)" p="x-1" border="rounded 1">
              {{ item.lost_Attr }}
            </div>
            <div flex="grow" />
            <div text="secondary" m="t-1">{{ item.time }}</div>
          </div>
          <div m="x-1">{{ item.item }}</div>
        </div>
      </template>
      <template #default>
        <div p="y-2" text="xs secondary">拾獲地點： {{ item.location }}</div>
        <n-image :src="showImage(item)" />
      </template>
      <template #footer>
        <div
          flex="~"
          p="x-4 y-2"
          v-if="isManager"
          justify="center items-center"
        >
          <n-button flex="~ grow" size="medium" type="info" quaternary>
            <template #icon>
              <n-icon :size="18"><edit /></n-icon>
            </template>
            <div>編輯</div>
          </n-button>
          <div m="1" p="0.8px" bg="gray-200" />
          <n-button flex="~ grow" size="medium" type="error" quaternary>
            <template #icon>
              <n-icon :size="18"><trash /></n-icon>
            </template>
            <div>刪除</div>
          </n-button>
        </div>
      </template>
    </n-card>
    <div p="7" />
    <!-- Card: New Lost Item -->
    <n-card
      v-if="isManager"
      :hoverable="true"
      pos="fixed bottom-16"
      footer-style="padding: 0px;"
    >
      <template #footer>
        <div class="flex justify-center py-4 px-12">
          <n-button flex="~ grow" type="success" ghost @click="openAppend">
            <template #icon>
              <n-icon :size="18"><add /></n-icon>
            </template>
            <div>新增遺失物</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </div>

  <!-- Overlay: Confirm Delete -->
  <n-modal v-model:show="showDelete">
    <n-card
      w="3/4 min-30"
      title="確定要刪除？"
      :header-style="{ 'align-self': 'center' }"
    >
      <div text="sm center secondary" pb="2">請注意，刪除後無法復原</div>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-2">
          <n-button type="error" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><trash /></n-icon>
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
              <n-icon :size="18"><back /></n-icon>
            </template>
            <div>取消</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </n-modal>

  <!-- Overlay: New Lost Information -->
  <n-modal v-model:show="showAppend">
    <n-card title="新增遺失物" :header-style="{ 'align-self': 'center' }">
      <n-form
        ref="formRef"
        :label-width="100"
        :model="lostObject"
        require-mark-placement="right-hanging"
        h="120"
        overflow="auto"
      >
        <n-form-item label="遺失物品" path="topic">
          <n-input v-model:value="lostObject.item" placeholder="輸入物品名稱" />
        </n-form-item>
        <n-form-item label="遺失時間" path="title">
          <n-date-picker
            w="full"
            v-model:value="timeValue"
            type="datetime"
            clearable
          />
        </n-form-item>
        <n-form-item label="遺失地點" path="title">
          <n-input
            v-model:value="lostObject.location"
            placeholder="請輸入地點"
          />
        </n-form-item>
        <n-form-item label="屬性" path="title">
          <n-select
            v-model:value="lostObject.lost_Attr"
            :options="attrOption"
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
      </n-form>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-12">
          <n-button @click="appendLost" type="primary" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><save /></n-icon>
            </template>
            <div>儲存</div>
          </n-button>
          <n-button
            @click="showAppend = false"
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
      </template>
    </n-card>
  </n-modal>

  <!-- Overlay: Edit Lost Information -->
  <n-modal v-model:show="showEdit">
    <n-card title="編輯公告" :header-style="{ 'align-self': 'center' }">
      <n-form
        ref="formRef"
        :label-width="80"
        require-mark-placement="right-hanging"
      >
        <n-form-item label="標題" path="topic">
          <n-input placeholder="輸入標題" />
        </n-form-item>
        <n-form-item label="內文" path="context">
          <template #header-extra> 必填 </template>
          <n-input type="textarea" placeholder="輸入內文" />
        </n-form-item>
      </n-form>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-12">
          <n-button type="primary" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><save /></n-icon>
            </template>
            <div>儲存</div>
          </n-button>
          <n-button @click="showEdit = false" type="tertiary" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><back /></n-icon>
            </template>
            <div>取消</div>
          </n-button>
        </div>
      </template>
    </n-card>
  </n-modal>
</template>

<script setup lang="ts">
import axios from "axios";
import router from "@/router";
import store from "../scripts/vuex";
import { Lost } from "../scripts/types";
import { ref, reactive, computed, onMounted } from "vue";

// Naive UI & Icons
import {
  NIcon,
  NForm,
  NCard,
  NModal,
  NInput,
  NImage,
  NButton,
  NSelect,
  NUpload,
  FormRules,
  NFormItem,
  NDatePicker,
  FormItemRule,
} from "naive-ui";
import trash from "../assets/icon/iTrash.vue";
import back from "../assets/icon/iRefund.vue";
import add from "../assets/icon/iAdd.vue";
import edit from "../assets/icon/iEdit.vue";
import save from "../assets/icon/iSave.vue";
import { Ref } from "vue";

const timeValue = ref(0);
const attrOption = [
  { label: "遺失", value: "遺失" },
  { label: "拾獲", value: "拾獲" },
];
const isListEmpty = ref(true);
const lostItem = ref<Lost>();
const lostList = ref<Lost[]>([]);
const formData = new FormData();
const lostObject = reactive<Lost>({
  id: 0,
  item: "",
  time: "",
  photo: "",
  location: "",
  lost_Attr: attrOption[0].label,
});

// Visible of Overlay Modals
const showAppend = ref(false);
const showEdit = ref(false);
const showDelete = ref(false);
// Judge if the user is manager
const isManager = computed(() => {
  const role = store.state?.userinfo?.role as unknown as string;
  if (role == "admin" || role == "mrt_admin") return true;
  else return false;
});

onMounted(async () => {
  try {
    const res = await axios.get("http://localhost:3000/api/mrt_admin/lost");
    lostList.value = res.data.data;
    isListEmpty.value = lostList.value.length === 0;
    console.log(lostList.value);
  } catch (err) {
    console.log(err);
  }
});

// Handle Appending new lost information
const appendLost = async () => {
  lostObject.time = new Date(timeValue.value).toLocaleString();
  formData.append("item", lostObject.item);
  formData.append("time", lostObject.time);
  formData.append("location", lostObject.location);
  formData.append("lost_Attr", lostObject.lost_Attr);
  try {
    const res = await axios.post(
      "http://localhost:3000/api/mrt_admin/lost",
      formData
    );
    console.log(res.data);
    showAppend.value = false;
    router.go(0);
  } catch (err) {
    console.log(err);
  }
};

// Open the overlay modals
function openAppend() {
  showAppend.value = true;
  timeValue.value = Date.now();
  lostObject.item = "";
  lostObject.location = "";
  lostObject.lost_Attr = attrOption[0].label;
}
function openEdit(target: Lost) {
  showEdit.value = true;
  lostObject.id = target.id;
  lostObject.item = target.item;
  lostObject.time = target.time;
  lostObject.location = target.location;
  lostObject.lost_Attr = target.lost_Attr;
}
function openDelete(target: Lost) {
  showDelete.value = true;
  lostObject.id = target.id;
}
function setAttrClass(item: Lost) {
  if (item.lost_Attr == attrOption[0].label) {
    return "text-orange border-yellow";
  } else if (item.lost_Attr == attrOption[1].label) {
    return "text-blue border-blue";
  }
}

function showImage(item: Lost) {
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
</script>

<style scoped>
::-webkit-scrollbar {
  display: none;
}
</style>
