<template>
  <div m="y-2" space="y-2">
    <n-card
      v-for="item in AllPost"
      :key="item?.id"
      footer-style="padding: 0;"
      :bordered="false"
    >
      <template #header>
        <div justify="items-end" flex="~" w="full">
          <div flex="grow" text="lg title">
            {{ item.topic }}
          </div>
          <div mt="1.5" text="xs secondary" font="normal">
            {{ itemDate(item.created_at, item.updated_at) }}
          </div>
        </div>
      </template>
      <div style="white-space: pre-line">
        {{ item.context }}
      </div>

      <template #footer>
        <div
          flex="~"
          justify="center items-center"
          p="x-4 y-2"
          v-if="roleisAdmin"
        >
          <n-button
            @click="showOldAnnounce(item.id)"
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
          <div m="1" p="0.8px" bg="gray-200" />
          <n-button
            @click="showConfirmDelete(item.id)"
            flex="~ grow"
            size="medium"
            type="error"
            quaternary
          >
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
      v-if="roleisAdmin"
      pos="fixed bottom-16"
      footer-style="padding: 0px;"
      :hoverable="true"
    >
      <template #footer>
        <div class="flex justify-center py-4 px-12">
          <n-button
            flex="~ grow"
            type="success"
            ghost
            @click="showNewAnnounce = true"
          >
            <template #icon>
              <n-icon :size="18"><add /></n-icon>
            </template>
            新增公告
          </n-button>
        </div>
      </template>
    </n-card>
  </div>

  <!-- Overlay: Confirm Delete -->
  <n-modal v-model:show="ConfirmDeleteshow">
    <n-card
      w="3/4 min-30"
      title="確定要刪除？"
      :header-style="{ 'align-self': 'center' }"
    >
      <div text="sm center secondary" pb="2">請注意，刪除後無法復原</div>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-2">
          <n-button @click="deleteAnnounce" type="error" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><trash /></n-icon>
            </template>
            <div>刪除</div>
          </n-button>
          <n-button
            @click="ConfirmDeleteshow = false"
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
  <!-- Overlay: New Annoucement -->
  <n-modal v-model:show="showNewAnnounce">
    <n-card title="新增公告" :header-style="{ 'align-self': 'center' }">
      <n-form
        ref="formRef"
        :label-width="100"
        :model="model"
        :rules="rules"
        require-mark-placement="right-hanging"
      >
        <n-form-item label="標題" path="topic">
          <n-input v-model:value="model.topic" placeholder="輸入標題" />
        </n-form-item>
        <n-form-item label="內文" path="context">
          <template #header-extra> 必填 </template>
          <n-input
            v-model:value="model.context"
            type="textarea"
            placeholder="輸入內文"
          />
        </n-form-item>
      </n-form>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-12">
          <n-button @click="addNewAnnounce" type="primary" flex="grow" ghost>
            <template #icon>
              <n-icon :size="18"><save /></n-icon>
            </template>
            <div>儲存</div>
          </n-button>
          <n-button
            @click="showNewAnnounce = false"
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

  <!-- Overlay: Edit Annoucement -->
  <n-modal v-model:show="OldAnnounceshow">
    <n-card title="編輯公告" :header-style="{ 'align-self': 'center' }">
      <n-form
        ref="formRef"
        :label-width="80"
        :model="model"
        :rules="rules"
        require-mark-placement="right-hanging"
      >
        <n-form-item label="標題" path="topic">
          <n-input v-model:value="model.oldtopic" placeholder="輸入標題" />
        </n-form-item>
        <n-form-item label="內文" path="context">
          <template #header-extra> 必填 </template>
          <n-input
            v-model:value="model.oldcontext"
            type="textarea"
            placeholder="輸入內文"
          />
        </n-form-item>
      </n-form>
      <template #footer>
        <div flex="~ gap-8" class="justify-center px-12">
          <n-button
            @click="SubmitEditAnnounce"
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
            @click="OldAnnounceshow = false"
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
</template>

<script setup lang="ts">
import axios from "axios";
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
import store from "/src/scripts/vuex.ts";
import { ref, reactive, computed, onMounted } from "vue";
import type { Post } from "../scripts/types.ts";
import { watchOnce } from "@vueuse/core";
import router from "@/router";
const AllPost = ref<Post | null>(null);
const showNewAnnounce = ref(false);
const ConfirmDeleteshow = ref(false);
const OldAnnounceshow = ref(false);
const OldAnnounceindex = ref(-1);
const AnnouncementID = ref(-1);
const maxindex = ref<number>(0);
const roleisAdmin = computed(() => {
  if ((store.state?.userinfo?.role as string) == "admin") {
    return true;
  } else if ((store.state?.userinfo?.role as string) == "mrt_admin") {
    return true;
  }
  return false;
});
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
function reloadAnnouncement() {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/announcement")
    .then(function (response) {
      //console.log(response);
      AllPost.value = response.data.data.map(function (item: Post) {
        return {
          id: item.id,
          topic: item.topic,
          context: item.context,
          member_id: item.member_id,
          created_at: item.created_at,
          updated_at: item.updated_at,
        };
      });
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
onMounted(() => {
  reloadAnnouncement();
});
const model = reactive({
  topic: "",
  context: "",
  oldtopic: "",
  oldcontext: "",
});

function addNewAnnounce() {
  AllPost.value.forEach((item, index) => {
    if (maxindex.value < AnnouncementID.value) {
      maxindex.value = index;
    }
  });
  //axios post
  axios
    .post("http://localhost:3000/api/mrt_admin/announcement", {
      topic: model.topic,
      context: model.context,
    })
    .then(function (response) {
      console.log(response);
      showNewAnnounce.value = false;
      AllPost.value.push(response.data.data);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function showConfirmDelete(id: number) {
  ConfirmDeleteshow.value = true;
  AnnouncementID.value = id;
  //console.log(AnnouncementID);
}

function showOldAnnounce(id: number) {
  OldAnnounceshow.value = true;
  AnnouncementID.value = id;
  //console.log(AnnouncementID);
  AllPost.value.forEach((item, index) => {
    if (item.id == AnnouncementID.value) {
      OldAnnounceindex.value = index;
    }
  });
  //console.log(OldAnnounceindex.value);
  model.oldtopic = AllPost.value[OldAnnounceindex.value]?.topic;
  model.oldcontext = AllPost.value[OldAnnounceindex.value]?.context;
}
function SubmitEditAnnounce() {
  //axios patch
  axios
    .patch(
      "http://localhost:3000/api/mrt_admin/announcement/" +
        (AnnouncementID.value as unknown as string),
      {
        topic: model.oldtopic,
        context: model.oldcontext,
      }
    )
    .then(function (response) {
      console.log(response);
      OldAnnounceshow.value = false;
      reloadAnnouncement();
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}

function deleteAnnounce() {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/announcement/" +
        (AnnouncementID.value as unknown as string)
    )
    .then(function (response) {
      console.log(response);
      ConfirmDeleteshow.value = false;
      reloadAnnouncement();
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}

const rules: FormRules = {
  topic: [
    {
      required: true,
      validator(rule: FormItemRule, value: string) {
        if (!value) {
          return new Error("Topic is required");
        }
        return true;
      },
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
</script>
