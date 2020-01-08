<template>
  <div class="max-w-md m-auto py-10">
    <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">Add a new brand</h3>
    <form action="" @submit.prevent="addBrand">
      <div class="mb-6">
        <input class="input"
               autofocus autocomplete="off"
               placeholder="Type a brand name"
               v-model="newBrand.name" />
      </div>
      <input type="submit" value="Add Brand" class="cursor-pointer no-underline block w-full py-4 items-center justify-center btn btn-blue" />
    </form>

    <hr class="border border-grey-light my-6" />

    <ul class="list-reset mt-4">
      <li class="py-4" v-for="brand in brands" :key="brand.id" :brand="brand">

        <div class="flex items-center justify-between flex-wrap">
          <p class="block flex-1 font-mono font-semibold flex items-center ">
            <svg class="fill-current text-indigo w-6 h-6 mr-2" viewBox="0 0 20 20" width="20" height="20"><title>brand</title><path d="M15.75 8l-3.74-3.75a3.99 3.99 0 0 1 6.82-3.08A4 4 0 0 1 15.75 8zm-13.9 7.3l9.2-9.19 2.83 2.83-9.2 9.2-2.82-2.84zm-1.4 2.83l2.11-2.12 1.42 1.42-2.12 2.12-1.42-1.42zM10 15l2-2v7h-2v-5z"></path></svg>
            {{ brand.name }}
          </p>

          <button class="bg-tranparent text-sm hover:bg-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
                  @click.prevent="editBrand(brand)">Edit</button>

          <button class="bg-transprent text-sm hover:bg-red no-underline font-bold py-2 px-4 rounded border border-red"
                  @click.prevent="removeBrand(brand)">Delete</button>
        </div>

        <div v-if="brand == editedBrand">
          <form action="" @submit.prevent="updateBrand(brand)">
            <div class="mb-6 p-4 bg-white rounded border border-grey-light mt-4">
              <input class="input border border-dark rounded py-1 px-4 w-full" v-model="brand.name" />
              <div>
                <button @click.prevent="cancelEdit(brand)" type="button" class="my-2 cursor-pointer border-transparent border-4 text-indigo-400 hover:text-indigo-900">
                  Cancel
                </button>
                <input type="submit" value="Update" class=" my-2 text-sm cursor-pointer btn btn-blue">
              </div>
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Brands',
  data () {
    return {
      brands: [],
      newBrand: [],
      error: '',
      editedBrand: ''
    }
  },
  created () {
    if (!localStorage.loggedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/api/v1/brands')
        .then(response => { this.brands = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addBrand () {
      const value = this.newBrand
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/brands/', { brand: { name: this.newBrand.name } })
        .then(response => {
          this.brands.push(response.data)
          this.newBrand = ''
        })
        .catch(error => this.setError(error, 'Cannot create brand'))
    },
    removeBrand (brand) {
      this.$http.secured.delete(`/api/v1/brands/${brand.id}`)
        .then(response => {
          this.brands.splice(this.brands.indexOf(brand), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete brand'))
    },
    editBrand (brand) {
      this.cachedBrand = Object.assign({}, brand)
      this.editedBrand = brand
    },
    updateBrand (brand) {
      this.editedBrand = ''
      this.$http.secured.patch(`/api/v1/brands/${brand.id}`, { brand: { name: brand.name } })
        .catch(error => this.setError(error, 'Cannot update brand'))
    },
    cancelEdit (brand) {
      this.editedBrand = ''
      Object.assign(brand, this.cachedBrand)
    }
  }
}
</script>
