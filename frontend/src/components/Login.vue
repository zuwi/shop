<template>
  <div class="max-w-sm m-auto my-8">
    <div class="border p-10 border-grey-light shadow rounded">
      <h3 class="text-2xl mb-6 text-grey-darkest">Login</h3>
      <form @submit.prevent="login">
        <div class="text-red" v-if="error">
          {{ error }}
        </div>

        <div class="mb-6">
          <label for="email" class="label">Email</label>
          <input type="email" v-model="email" class="input" id="email" placeholder="Email">
        </div>
        <div class="mb-6">
          <label for="password" class="label">Password</label>
          <input type="password" v-model="password" class="input" id="password" placeholder="Password">
        </div>
        <button type="submit" class="btn btn-blue">Login</button>

        <div class="my-4"><router-link to="/registration" class="link-grey">Registration</router-link></div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Login',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkLoggedIn()
  },
  updated () {
    this.checkLoggedIn()
  },
  methods: {
    login () {
      this.$http.plain.post('/login', { email: this.email, password: this.password })
        .then(response => this.loginSuccessful(response))
        .catch(error => this.loginFailed(error))
    },
    loginSuccessful (response) {
      if (!response.data.csrf) {
        this.loginFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.loggedIn = true
      this.error = ''
      this.$router.replace('/items')
    },
    loginFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.csrf
      delete localStorage.loggedIn
    },
    checkLoggedIn () {
      if (localStorage.loggedIn) {
        this.$router.replace('/items')
      }
    }
  }
}
</script>
