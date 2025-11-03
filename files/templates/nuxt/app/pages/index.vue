<script setup lang="ts">
const { data } = await useFetch('/api/hello')
</script>

<template>
    <div class="flex-1 grid place-items-center">
        <h1 class="text-4xl">{{ data }}</h1>
    </div>
</template>