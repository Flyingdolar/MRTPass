import { createRouter, createWebHashHistory, RouteRecordRaw } from "vue-router";
import HomeView from "../views/HomeView.vue";

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "home",
    component: HomeView,
  },
  {
    path: "/about",
    name: "about",
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/AboutView.vue"),
  },
  {
    path: "/post",
    name: "viewpost",
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/submitPost.vue"),
  },
  {
    path: "/MRTInfo",
    name: "MRTInfo",
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/MRTInfo.vue"),
  },
  {
    path: "/MRTAnnounce",
    name: "MRTAnnounce",
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/MRTAnnounce.vue"),
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
