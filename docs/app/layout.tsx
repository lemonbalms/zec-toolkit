import { Footer, Layout, Navbar } from 'nextra-theme-docs'
import { Head, Search } from 'nextra/components'
import { getPageMap } from 'nextra/page-map'
import 'nextra-theme-docs/style.css'
import type { ReactNode } from 'react'

export const metadata = {
  title: {
    default: 'ZEC Toolkit',
    template: '%s – ZEC Toolkit',
  },
  description: 'Claude Code를 위한 개발 오케스트레이션 플러그인',
  openGraph: {
    title: 'ZEC Toolkit',
    description: 'Claude Code를 위한 개발 오케스트레이션 플러그인',
  },
}

const navbar = (
  <Navbar
    logo={<span style={{ fontWeight: 800, fontSize: '1.1rem' }}>ZEC Toolkit</span>}
    projectLink="https://github.com/lemonbalms/zec-toolkit"
  >
    <Search
      placeholder="문서 검색..."
      errorText="검색 인덱스를 불러올 수 없습니다."
      emptyResult="결과가 없습니다."
    />
  </Navbar>
)

const footer = (
  <Footer>MIT License © {new Date().getFullYear()} zec-toolkit</Footer>
)

export default async function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="ko" dir="ltr" suppressHydrationWarning>
      <Head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      </Head>
      <body>
        <Layout
          navbar={navbar}
          pageMap={await getPageMap()}
          docsRepositoryBase="https://github.com/lemonbalms/zec-toolkit/tree/main/docs"
          footer={footer}
          sidebar={{ defaultMenuCollapseLevel: 1, toggleButton: true }}
          toc={{ title: '목차' }}
          editLink="이 페이지 수정하기 →"
          feedback={{ content: '피드백 보내기 →', labels: 'feedback' }}
        >
          {children}
        </Layout>
      </body>
    </html>
  )
}
