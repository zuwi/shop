<template>
  <div class="max-w-sm m-auto my-8">
    <div class="border p-10 border-grey-light shadow rounded">
      <h3 class="text-2xl mb-6 text-grey-darkest">Registration</h3>
      <form @submit.prevent="registration">
        <div class="text-red" v-if="error">
          {{ error }}
        </div>

        <div class="mb-6">
          <label for="email" class="label">Email</label>
          <input type="email" v-model="email" class="input" id="email" placeholder="Email">
        </div>
        <div class="mb-6">
          <label for="firstname" class="label">Firstname</label>
          <input type="firstname" v-model="firstname" class="input" id="firstname" placeholder="Firstname">
        </div>
        <div class="mb-6">
          <label for="lastname" class="label">Lastname</label>
          <input type="lastname" v-model="lastname" class="input" id="lastname" placeholder="Lastname">
        </div>
        <div class="mb-6">
          <label for="password" class="label">Password</label>
          <input type="password" v-model="password" class="input" id="password" placeholder="Password">
        </div>
        <div class="mb-6">
          <label for="password" class="label">Password Confirmation</label>
          <input type="password" v-model="password_confirmation" class="input" id="password_confirmation" placeholder="Password">
        </div>
        <button type="submit" class="btn btn-blue">Registration</button>

        <div class="my-4"><router-link to="/" class="link-grey">Login</router-link></div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Registration',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      firstname: '',
      lastname: '',
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
    registration () {
      this.$http.plain.post('/registration', { email: this.email, password: this.password, password_confirmation: this.password_confirmation, firstname: this.firstname, lastname: this.lastname })
        .then(response => this.registrationSuccessful(response))
        .catch(error => this.registrationFailed(error))
    },
    registrationSuccessful (response) {
      if (!response.data.csrf) {
        this.registrationFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.loggedIn = true
      this.error = ''
      this.$router.replace('/items')
    },
    registrationFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
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
