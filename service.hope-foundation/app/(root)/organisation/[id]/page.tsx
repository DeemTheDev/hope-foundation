import React from "react";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import Tabs from "./components/Tabs";
import Navbar from "./components/Navbar";

export default async function Organisation({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const cookieStore = cookies();
  const authenticatedOrgId = (await cookieStore).get("org_id")?.value;

  // Double check authentication on server side
  if (!authenticatedOrgId || authenticatedOrgId !== id) {
    redirect("/auth");
  }

  return (
    <>
      <div>
        <Navbar id={id} />
      </div>
      <div className="w-full flex flex-row justify-center mt-6 ">
        <div className="h-auto">
          <Tabs id={id} />
        </div>
      </div>
    </>
  );
}
