// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://kijonghan.github.io',
  base: '/rxdart_devtools',
  integrations: [
    starlight({
      title: 'rxdart_devtools',
      description:
        'A DevTools extension for inspecting RxDart streams in your Flutter app.',
      social: {
        github: 'https://github.com/KijongHan/rxdart_devtools',
      },
      sidebar: [
        {
          label: 'Overview',
          slug: 'index',
        },
        {
          label: 'Tutorial',
          items: [
            { label: 'Getting started', slug: 'tutorial/getting-started' },
          ],
        },
        {
          label: 'How-to guides',
          autogenerate: { directory: 'how-to' },
        },
        {
          label: 'Reference',
          items: [
            {
              label: 'API docs (pub.dev)',
              link: 'https://pub.dev/documentation/rxdart_devtools/latest/',
              attrs: { target: '_blank', rel: 'noopener' },
            },
          ],
        },
      ],
    }),
  ],
});
