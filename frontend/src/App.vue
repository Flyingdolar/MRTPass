<template>
  <n-layout flex="~ col" p="y-4" bg="white">
    <n-space justify="space-between" p="4" bg="white">
      <img src="./assets/Title.png" h="8" />
      <div p="x-2 y-1" border="1 rounded-lg">
        <div text="sm secondary">訪客使用者</div>
      </div>
    </n-space>
    <n-layout-content h="160" bg="gray-100">
      <router-view />
    </n-layout-content>
    <n-layout-footer class="flex-grow-0">
      <n-space justify="space-around" p="4" bg="white">
        <router-link to="/">
          <n-space>
            <div text="secondary">捷運資訊</div>
          </n-space>
        </router-link>

        <router-link to="/post">
          <n-space>
            <div text="secondary">捷運周邊</div>
          </n-space>
        </router-link>

        <router-link to="/about">
          <n-space>
            <div text="secondary">遺失物</div>
          </n-space>
        </router-link>

        <router-link to="/account">
          <n-space>
            <div text="secondary">我的帳號</div>
          </n-space>
        </router-link>
      </n-space>
    </n-layout-footer>
  </n-layout>
</template>

<script setup lang="ts">
import {
  NSpace,
  NLayout,
  NAvatar,
  NLayoutHeader,
  NLayoutContent,
  NLayoutFooter,
} from "naive-ui";
</script>
