const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const root=path.resolve(__dirname,'../service.hope-foundation');
const ts=require(path.join(root,'node_modules/typescript'));
(async()=>{
 for(const name of ['app/api/auth/upload/route.ts','app/api/auth/upload/organisation/route.ts']) {
  let constructed=0,sent=0;
  const env={};
  const context={exports:{}, process:{env}, Buffer, console:{error(){}}, require(id){
   if(id==='next/server')return {NextResponse:{json:(body,options)=>({body,status:options?.status||200})}};
   if(id==='@aws-sdk/client-s3')return {S3Client:class{constructor(){constructed++;}async send(){sent++;}},PutObjectCommand:class{}};
   if(id==='@/db')return {addOrganisationImage:async()=>{}};
   throw Error(id);
  }};
  vm.runInNewContext(ts.transpileModule(fs.readFileSync(path.join(root,name),'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS}}).outputText,context);
  assert.equal(constructed,0,'Import must not require storage configuration');
  const field='image';
  const file={name:'fixture.png',type:'image/png',arrayBuffer:async()=>new ArrayBuffer(1)};
  const request={formData:async()=>({get:key=>key===field?file:key==='organisationId'?'1':null})};
  const unavailable=await context.exports.POST(request);
  assert.equal(unavailable.status,503);
  assert.equal(sent,0);
  Object.assign(env,{NEXT_AWS_S3_REGION:'fixture-region',NEXT_AWS_S3_ACCESS_KEY_ID:'fixture',NEXT_AWS_S3_SECRET_ACCESS_KEY:'fixture',NEXT_AWS_S3_BUCKET_NAME:'fixture'});
  const valid=await context.exports.POST(request);
  assert.equal(valid.status,200);assert.equal(sent,1);
  console.log('PASS:',name,'import without settings; missing-config 503; configured mocked upload.');
 }
})().catch(error=>{console.error(error);process.exitCode=1;});
