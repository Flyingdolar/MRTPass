<template>
  <n-space justify="center">
    <n-card
      ><div v-for="item in AllPost" :key="item?.id">
        <n-space
          ><n-card :title="item.topic"
            >{{ item.context
            }}<template #footer
              ><n-space justify="space-around" v-if="roleisAdmin">
                <n-button @click="showOldAnnounce(item.id)">編輯</n-button
                ><n-popconfirm @positive-click="handlePositiveClick(item.id)"
                  ><template #trigger><n-button>刪除</n-button></template
                  >確認刪除公告</n-popconfirm
                >
              </n-space></template
            ></n-card
          ></n-space
        >
      </div>
      <n-space v-if="roleisAdmin" justify="center">
        <n-button @click="showNewAnnounce = true">新增公告</n-button>
      </n-space>
      <n-modal v-model:show="showNewAnnounce">
        <n-card title="新增公告" :header-style="{ 'align-self': 'center' }">
          <n-form
            ref="formRef"
            :label-width="80"
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
            <n-space justify="space-around">
              <n-button attr-type="button" @click="addNewAnnounce">
                儲存
              </n-button>
              <n-button attr-type="button" @click="showNewAnnounce = false">
                取消
              </n-button>
            </n-space>
          </template>
        </n-card>
      </n-modal>
    </n-card>
  </n-space>
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
        <n-space justify="space-around">
          <n-button attr-type="button" @click="SubmitEditAnnounce">
            儲存
          </n-button>
          <n-button attr-type="button" @click="OldAnnounceshow = false">
            取消
          </n-button>
        </n-space>
      </template>
    </n-card>
  </n-modal>
</template>

<script setup lang="ts">
import axios from "axios";
import {
  NForm,
  NInput,
  NFormItem,
  FormRules,
  FormInst,
  NButton,
  NCard,
  FormItemRule,
  NSpace,
  NModal,
  NPopconfirm,
} from "naive-ui";
import store from "/src/scripts/vuex.ts";
import { ref, reactive, computed, onMounted } from "vue";
import type { Post } from "../scripts/types.ts";
import { watchOnce } from "@vueuse/core";
import router from "@/router";
const AllPost = ref<Post | null>(null);
const showNewAnnounce = ref(false);
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
onMounted(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/announcement")
    .then(function (response) {
      //console.log(response);
      AllPost.value = response.data.data.map(function (item, index, array) {
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
      router.go(0);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
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
      AllPost.value[OldAnnounceindex.value].topic = model.oldtopic;
      AllPost.value[OldAnnounceindex.value].context = model.oldcontext;
      OldAnnounceshow.value = false;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function handlePositiveClick(id: number) {
  AnnouncementID.value = id;
  deleteAnnounce();
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
      router.go(0);
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
