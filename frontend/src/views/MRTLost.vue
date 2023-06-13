<template>
  <div m="y-2" space="y-2">
    <n-card footer-style="padding: 0;" :bordered="false">
      <template #header>
        <div justify="items-end" flex="~" w="full">
          <div flex="grow" text="lg title"></div>
          <div mt="1.5" text="xs secondary" font="normal"></div>
        </div>
      </template>
      <template #footer>
        <div
          flex="~"
          justify="center items-center"
          p="x-4 y-2"
          v-if="isManager"
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
    <!-- Card: New Annoucement -->
    <n-card
      pos="fixed bottom-16"
      footer-style="padding: 0px;"
      :hoverable="true"
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
      >
        <n-form-item label="遺失物品" path="topic">
          <n-input v-model:value="lostObject.item" placeholder="輸入物品名稱" />
        </n-form-item>
        <n-form-item label="遺失時間" path="title">
          <n-input v-model:value="lostObject.time" placeholder="請輸入時間" />
        </n-form-item>
        <n-form-item label="遺失地點" path="title">
          <n-input
            v-model:value="lostObject.location"
            placeholder="請輸入地點"
          />
        </n-form-item>
        <n-form-item label="屬性" path="title">
          <n-input v-model:value="lostObject.lost_Attr" placeholder="屬性" />
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
  NForm,
  NInput,
  NIcon,
  NFormItem,
  FormRules,
  NDivider,
  NButton,
  NCard,
  FormItemRule,
  NSpace,
  NModal,
} from "naive-ui";
import trash from "../assets/icon/iTrash.vue";
import back from "../assets/icon/iRefund.vue";
import add from "../assets/icon/iAdd.vue";
import edit from "../assets/icon/iEdit.vue";
import save from "../assets/icon/iSave.vue";
import { Ref } from "vue";

const lost = "遺失";
const found = "拾獲";
const lostList = ref<Lost[]>([]);
// Let lostObject as a reactive object in Lost type
const lostObject = reactive<Lost>({
  id: 0,
  item: "",
  time: "",
  location: "",
  lost_Attr: lost,
});

// Visible of Overlay Modals
const showAppend = ref(false);
const showEdit = ref(false);
const showDelete = ref(false);
// Judge if the user is manager
const isManager = computed(() => {
  return true;
});

onMounted(async () => {
  try {
    const res = await axios.get("http://localhost:3000/api/mrt_admin/lost");
    console.log(res.data);
  } catch (err) {
    console.log(err);
  }
});

// Handle Appending new lost information
const appendLost = async () => {
  try {
    const res = await axios.post(
      "http://localhost:3000/api/mrt_admin/lost",
      lostObject
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
  // Reset the form
  lostObject.item = "";
  lostObject.time = "";
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
</script>
