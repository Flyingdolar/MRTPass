import { createStore } from "vuex";
import type { Role, User } from "./types";

export interface State {
  role: string | undefined;
  username: string;
  user: User | undefined;
  isLogin: boolean;
}

const store = createStore<State>({
  state: {
    role: undefined,
    username: "",
    user: undefined,
    isLogin: false,
  },
  getters: {
    role: (state) => {
      return state.role;
    },
    username: (state) => {
      return state.username;
    },
    user: (state) => {
      return state.username;
    },
    isLogin: (state) => {
      return state.isLogin;
    },
  },
  actions: {
    role(ctx, newRole) {
      ctx.commit("role", newRole);
    },
    username: (ctx, name) => {
      ctx.commit("username", name);
    },
    user: (ctx, user) => {
      ctx.commit("user", user);
    },
    isLogin: (ctx, isLogin) => {
      ctx.commit("isLogin", isLogin);
    },
  },
  mutations: {
    async role(state, newRole) {
      state.role = newRole;
    },
    async username(state, newName) {
      state.username = newName;
    },
    async user(state, newUser) {
      state.user = newUser;
    },
    async isLogin(state, isLogin) {
      state.isLogin = isLogin;
    },
  },
});

export default store;
