import io
p='app/assets/companion/stage.js'
s=io.open(p,encoding='utf-8').read()
a="      zonesFrom = 'default';\n    }"
b=a+'''
    {
      const has=(i)=>zones.some((q)=>q.id===i);
      const cut=(id,ps)=>{const z=zones.find((q)=>q.id===id);if(!z)return;const d=(z.to-z.from)/ps.length;zones=zones.filter((q)=>q.id!==id);ps.forEach((n,i)=>zones.push({...z,id:n,from:z.from+d*i,to:z.from+d*(i+1)}))};
      if(!has('chest')&&!has('belly')&&!has('hip'))cut('body',['chest','belly','hip']);
      if(!has('thigh')&&!has('knee')&&!has('shin')&&!has('foot'))cut('legs',['thigh','knee','shin','foot']);
    }'''
assert s.count(a)==1
io.open(p,'w',encoding='utf-8').write(s.replace(a,b))
print('zones split ok')
