// proxy.ts (Next.js 16 renamed the middleware file convention to proxy)
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function proxy(request: NextRequest) {
  // Get the organisation ID from the URL
  const organisationId = request.nextUrl.pathname.split('/')[2]

  // Get the authenticated organisation from the session/cookies
  const authenticatedOrgId = request.cookies.get('org_id')?.value

  // If trying to access an organisation route
  if (request.nextUrl.pathname.startsWith('/organisation/')) {
    // Check if user is authenticated and accessing their own organisation
    if (!authenticatedOrgId || authenticatedOrgId !== organisationId) {
      // Redirect to login if not authenticated or trying to access wrong organisation
      return NextResponse.redirect(new URL('/auth', request.url))
    }
  }

  return NextResponse.next()
}

// Configure which routes to run the proxy on
export const config = {
  matcher: '/organisation/:path*'
}