
----Electric Gryphon's 3D Library----
----https://github.com/electricgryphon/Pico-8-Gryphon-3D-Engine-Library----
----From https://www.lexaloffle.com/bbs/?tid=28077----
----NOTE: Modified to reduce token usage----

hex_string_data = "0123456789abcdef"
char_to_hex = {}
for i=1,#hex_string_data do
    char_to_hex[sub(hex_string_data,i,i)]=i-1
end

function read_byte(string)
    return char_to_hex[sub(string,1,1)]*16+char_to_hex[sub(string,2,2)]
end

function read_2byte_fixed(string)
    local a=read_byte(sub(string,1,2))
    local b=read_byte(sub(string,3,4))
    local val =a*256+b
    return val/256
end

cur_string=""
cur_string_index=1
function load_string(string)
    cur_string=string
    cur_string_index=1
end

function read_vector()
    v={}
    for i=1,3 do
        text=sub(cur_string,cur_string_index,cur_string_index+4)
        value=read_2byte_fixed(text)
        v[i]=value
        cur_string_index+=4
    end
    return v
end

function read_face()
    f={}
    for i=1,3 do
        text=sub(cur_string,cur_string_index,cur_string_index+2)
        value=read_byte(text)
        f[i]=value
        cur_string_index+=2
    end
    return f
end

function read_vector_string(string)
    vector_list={}
    load_string(string)
    while(cur_string_index<#string)do
        vector=read_vector()
        add(vector_list,vector)
    end
        return vector_list
end

function read_face_string(string)
    face_list={}
    load_string(string)
    while(cur_string_index<#string)do
        face=read_face()
        add(face_list,face)
    end
        return face_list
end
------------------------------------------------------------end hex string data handling--------------------------------


-------------------------------------------------------------BEGIN CUT HERE-------------------------------------------------
------------------------------------------------------Electric Gryphon's 3D Library-----------------------------------------
----------------------------------------------------------------------------------------------------------------------------

k_color1=4
k_color2=5

k_screen_scale=80
k_x_center=64
k_y_center=64



z_clip=-3
z_max=-50

k_min_x=0
k_max_x=128
k_min_y=0
k_max_y=128



--These are used for the 2 scanline color shading scheme
double_color_list=  {{0,0,0,0,0,0,0,0,0,0},
                     {0,0,0,0,0,0,0,0,0,0},

                    {0,0,1,1,1,1,13,13,12,12},
                    {0,0,0,1,1,1,1,13,13,12},

                    {2,2,2,2,8,8,14,14,14,15},
                    {0,1,1,2,2,8,8,8,14,14},

                    {1,1,1,1,3,3,11,11,10,10},
                    {0,1,1,1,1,3,3,11,11,10},

                    {1,1,2,2,4,4,9,9,10,10},
                    {0,1,1,2,2,4,4,9,9,10},

                    {0,0,1,1,5,5,13,13,6,6},
                    {0,0,0,1,1,5,5,13,13,6},

                    {1,1,5,5,6,6,6,6,7,7},
                    {0,1,1,5,5,6,6,6,6,7},

                    {5,5,6,6,7,7,7,7,7,7},
                    {0,5,5,6,6,7,7,7,7,7},

                    {2,2,2,2,8,8,14,14,15,15},
                    {0,2,2,2,2,8,8,14,14,15},

                    {2,2,4,4,9,9,15,15,7,7},
                    {0,2,2,4,4,9,9,15,15,7},

                    {4,4,9,9,10,10,7,7,7,7},
                    {0,4,4,9,9,10,10,7,7,7},

                    {1,1,3,3,11,11,10,10,7,7},
                    {0,1,1,3,3,11,11,10,10,7},

                    {13,13,13,12,12,12,6,6,7,7},
                    {0,5,13,13,12,12,12,6,6,7},

                    {1,1,5,5,13,13,6,6,7,7},
                    {0,1,1,5,5,13,13,6,6,7},

                    {2,2,2,2,14,14,15,15,7,7},
                    {0,2,2,2,2,14,14,15,15,7},

                    {4,4,9,9,15,15,7,7,7,7},
                    {0,4,4,9,9,15,15,7,7,7}
                    }


k_ambient=.3
function color_faces(object,base)
    --local p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z


        for i=1,#object.faces do
            local face=object.faces[i]
        --for face in all(object.faces)do
            local p1x=object.t_vertices[face[1]][1]
            local p1y=object.t_vertices[face[1]][2]
            local p1z=object.t_vertices[face[1]][3]
            local p2x=object.t_vertices[face[2]][1]
            local p2y=object.t_vertices[face[2]][2]
            local p2z=object.t_vertices[face[2]][3]
            local p3x=object.t_vertices[face[3]][1]
            local p3y=object.t_vertices[face[3]][2]
            local p3z=object.t_vertices[face[3]][3]



            local nx,ny,nz = vector_cross_3d(p1x,p1y,p1z,
                                p2x,p2y,p2z,
                                p3x,p3y,p3z)


        nx,ny,nz = normalize(nx,ny,nz)
        local b = vector_dot_3d(nx,ny,nz,light1_x,light1_y,light1_z)
        --see how closely the light vector and the face normal line up and shade appropriately

        -- print(nx.." "..ny.." "..nz,10,i*8+8,8)
        -- flip()
        if(object.color_mode==k_multi_color_dynamic)then
            face[4],face[5]=color_shade(object.base_faces[i][4], mid( b,0,1)*(1-k_ambient)+k_ambient )
        else
            face[4],face[5]=color_shade(base, mid( b,0,1)*(1-k_ambient)+k_ambient )
        end
    end

end


function color_shade(color,brightness)
    --return double_color_list[ (color+1)*2-1 ][flr(brightness*10)] , double_color_list[ (color+1)*2 ][flr(brightness*10)]
    local b= band(brightness*10,0xffff)
    local c= (color+1)*2
    return double_color_list[ c-1 ][b] , double_color_list[ c ][b]
end



light1_x=.1
light1_y=.35
light1_z=.2

--t_light gets written to
t_light_x=0
t_light_y=0
t_light_z=0

function init_light()
    light1_x,light1_y,light1_z=normalize(light1_x,light1_y,light1_z)
end

function update_light()
    t_light_x,t_light_y,t_light_z = rotate_cam_point(light1_x,light1_y,light1_z)
end

function normalize(x,y,z)
    local x1=shl(x,2)
    local y1=shl(y,2)
    local z1=shl(z,2)

    local inv_dist=1/sqrt(x1*x1+y1*y1+z1*z1)

    return x1*inv_dist,y1*inv_dist,z1*inv_dist

end

function    vector_dot_3d(ax,ay,az,bx,by,bz)
    return ax*bx+ay*by+az*bz
end

function    vector_cross_3d(px,py,pz,ax,ay,az,bx,by,bz)

     ax-=px
     ay-=py
     az-=pz
     bx-=px
     by-=py
     bz-=pz


    local dx=ay*bz-az*by
    local dy=az*bx-ax*bz
    local dz=ax*by-ay*bx
    return dx,dy,dz
end



k_colorize_static = 1
k_colorize_dynamic = 2
k_multi_color_static = 3
k_multi_color_dynamic = 4
k_preset_color = 5

--Function load object:
--object_vertices: vertex list for object (see above)
--object_faces: face list for object (see above)
--x,y,z: translated center for the the object
--ax,ay,az: rotation of object about these axis
--obstacle: boolean will the player collide with this?
--color mode:
--k_colorize_static = 1 : shade the model at init with one shaded color
--k_colorize_dynamic = 2 : color the model dynamically with one shade color -- slow
--k_multi_color_static = 3 : shade the model based on colors defined in face list
--k_multi_color_dynamic = 4 : shade the model dynamically based on colors define din face list -- slow
--k_preset_color = 5 : use the colors defined in face list only -- no lighting effects

function load_object(object_vertices,object_faces,x,y,z,ax,ay,az,obstacle,color_mode,color)
    object=new_object()

    object.vertices=object_vertices


    --make local deep copy of faces
    --if we don't car about on-demand shading we can share faces
    --but it means that objects will look wrong when rotated

    if(color_mode==k_preset_color)then
        object.faces=object_faces
    else
        object.base_faces=object_faces
        object.faces={}
        for i=1,#object_faces do
            object.faces[i]={}
            for j=1,#object_faces[i] do
                object.faces[i][j]=object_faces[i][j]
            end
        end
    end


    object.radius=0

    --make local deep copy of translated vertices
    --we share the initial vertices
    for i=1,#object_vertices do
        object.t_vertices[i]={}
            for j=1,3 do
                object.t_vertices[i][j]=object.vertices[i][j]
            end
    end

    object.ax=ax or 0
    object.ay=ay or 0
    object.az=az or 0

    transform_object(object)

    set_radius(object)
    set_bounding_box(object)

    object.x=x or 0
    object.y=y or 0
    object.z=z or 0

    object.color = color or 8
    object.color_mode= color_mode or k_colorize_static

    object.obstacle = obstacle or false

    if(obstacle)add(obstacle_list,object)

    if(color_mode==k_colorize_static or color_mode==k_colorize_dynamic or color_mode==k_multi_color_static )then
        color_faces(object,color)
    end



    return object
end

function set_radius(object)
    for vertex in all(object.vertices) do
        object.radius=max(object.radius,vertex[1]*vertex[1]+vertex[2]*vertex[2]+vertex[3]*vertex[3])
    end
    object.radius=sqrt(object.radius)
end

function set_bounding_box(object)
    for vertex in all(object.t_vertices) do

        object.min_x=min(vertex[1],object.min_x)
        object.min_y=min(vertex[2],object.min_y)
        object.min_z=min(vertex[3],object.min_z)
        object.max_x=max(vertex[1],object.max_x)
        object.max_y=max(vertex[2],object.max_y)
        object.max_z=max(vertex[3],object.max_z)
    end

end

function intersect_bounding_box(object_a, object_b)
    return
        ((object_a.min_x+object_a.x < object_b.max_x+object_b.x) and (object_a.max_x+object_a.x > object_b.min_x+object_b.x) and
         (object_a.min_y+object_a.y < object_b.max_y+object_b.y) and (object_a.max_y+object_a.y > object_b.min_y+object_b.y) and
         (object_a.min_z+object_a.z < object_b.max_z+object_b.z) and (object_a.max_z+object_a.z > object_b.min_z+object_b.z))
end

function new_object()
    object={}
    object.vertices={}
    object.faces={}

    object.t_vertices={}


    object.x=0
    object.y=0
    object.z=0

    object.rx=0
    object.ry=0
    object.rz=0

    object.tx=0
    object.ty=0
    object.tz=0

    object.ax=0
    object.ay=0
    object.az=0

    object.sx=0
    object.sy=0
    object.radius=10
    object.sradius=10
    object.visible=true

    object.render=true
    object.background=false
    object.ring=false

    object.min_x=100
    object.min_y=100
    object.min_z=100

    object.max_x=-100
    object.max_y=-100
    object.max_z=-100

    object.vx=0
    object.vy=0
    object.vz=0

    add(object_list,object)
    return object

end

function delete_object(object)
    del(object_list,object)
end


function new_triangle(p1x,p1y,p2x,p2y,p3x,p3y,z,c1,c2)

    add(triangle_list,{p1x=p1x,
                       p1y=p1y,
                       p2x=p2x,
                       p2y=p2y,
                       p3x=p3x,
                       p3y=p3y,
                       tz=z,
                       c1=c1,
                       c2=c2})




end

function draw_triangle_list()
    --for t in all(triangle_list) do
    for i=1,#triangle_list do
        local t=triangle_list[i]
        shade_trifill( t.p1x,t.p1y,t.p2x,t.p2y,t.p3x,t.p3y, t.c1,t.c2 )
    end
end

function update_visible(object)
        object.visible=false

        local px,py,pz = object.x-cam_x,object.y-cam_y,object.z-cam_z
        object.tx, object.ty, object.tz =rotate_cam_point(px,py,pz)

        object.sx,object.sy = project_point(object.tx,object.ty,object.tz)
        object.sradius=project_radius(object.radius,object.tz)
        object.visible= is_visible(object)
end

function cam_transform_object(object)
    if(object.visible)then

        for i=1, #object.vertices do
            local vertex=object.t_vertices[i]

            vertex[1]+=object.x - cam_x
            vertex[2]+=object.y - cam_y
            vertex[3]+=object.z - cam_z

            vertex[1],vertex[2],vertex[3]=rotate_cam_point(vertex[1],vertex[2],vertex[3])

        end


    end
end

function transform_object(object)




    if(object.visible)then
        generate_matrix_transform(object.ax,object.ay,object.az)
        for i=1, #object.vertices do
            local t_vertex=object.t_vertices[i]
            local vertex=object.vertices[i]

            t_vertex[1],t_vertex[2],t_vertex[3]=rotate_point(vertex[1],vertex[2],vertex[3])

        end


    end
end

function generate_matrix_transform(xa,ya,za)


    local sx=sin(xa)
    local sy=sin(ya)
    local sz=sin(za)
    local cx=cos(xa)
    local cy=cos(ya)
    local cz=cos(za)

    mat00=cz*cy
    mat10=-sz
    mat20=cz*sy
    mat01=cx*sz*cy+sx*sy
    mat11=cx*cz
    mat21=cx*sz*sy-sx*cy
    mat02=sx*sz*cy-cx*sy
    mat12=sx*cz
    mat22=sx*sz*sy+cx*cy

end

function generate_cam_matrix_transform(xa,ya,za)


    local sx=sin(xa)
    local sy=sin(ya)
    local sz=sin(za)
    local cx=cos(xa)
    local cy=cos(ya)
    local cz=cos(za)

    cam_mat00=cz*cy
    cam_mat10=-sz
    cam_mat20=cz*sy
    cam_mat01=cx*sz*cy+sx*sy
    cam_mat11=cx*cz
    cam_mat21=cx*sz*sy-sx*cy
    cam_mat02=sx*sz*cy-cx*sy
    cam_mat12=sx*cz
    cam_mat22=sx*sz*sy+cx*cy

end

function    matrix_inverse()
    local det = mat00* (mat11 * mat22- mat21 * mat12) -
                mat01* (mat10 * mat22- mat12 * mat20) +
                mat02* (mat10 * mat21- mat11 * mat20)
    local invdet=2/det



        mat00,mat01,mat02,mat10,mat11,mat12,mat20,mat21,mat22=(mat11 * mat22 - mat21 * mat12) * invdet,(mat02 * mat21 - mat01 * mat22) * invdet,(mat01 * mat12 - mat02 * mat11) * invdet,(mat12 * mat20 - mat10 * mat22) * invdet,(mat00 * mat22 - mat02 * mat20) * invdet,(mat10 * mat02 - mat00 * mat12) * invdet,(mat10 * mat21 - mat20 * mat11) * invdet,(mat20 * mat01 - mat00 * mat21) * invdet,(mat00 * mat11 - mat10 * mat01) * invdet

        --uh yeah I looked this one up :-)
end

function rotate_point(x,y,z)
    return (x)*mat00+(y)*mat10+(z)*mat20,(x)*mat01+(y)*mat11+(z)*mat21,(x)*mat02+(y)*mat12+(z)*mat22
end

function rotate_cam_point(x,y,z)
    return (x)*cam_mat00+(y)*cam_mat10+(z)*cam_mat20,(x)*cam_mat01+(y)*cam_mat11+(z)*cam_mat21,(x)*cam_mat02+(y)*cam_mat12+(z)*cam_mat22
end

function is_visible(object)

    if(object.tz+object.radius>z_max and object.tz-object.radius<z_clip and
       object.sx+object.sradius>0 and object.sx-object.sradius<128 and
       object.sy+object.sradius>0 and object.sy-object.sradius<128 )
       then return true else return false end
end

function    cross_product_2d(p0x,p0y,p1x,p1y,p2x,p2y)
    return ( ( (p0x-p1x)*(p2y-p1y)-(p0y-p1y)*(p2x-p1x)) > 0 )
end

function render_object(object)

    --project all points in object to screen space
    --it's faster to go through the array linearly than to use a for all()
    for i=1, #object.t_vertices do
        local vertex=object.t_vertices[i]
        vertex[4],vertex[5] = vertex[1]*k_screen_scale/vertex[3]+k_x_center,vertex[2]*k_screen_scale/vertex[3]+k_x_center
    end

    for i=1,#object.faces do
    --for face in all(object.faces) do
        local face=object.faces[i]

        local p1=object.t_vertices[face[1]]
        local p2=object.t_vertices[face[2]]
        local p3=object.t_vertices[face[3]]

        local p1x,p1y,p1z=p1[1],p1[2],p1[3]
        local p2x,p2y,p2z=p2[1],p2[2],p2[3]
        local p3x,p3y,p3z=p3[1],p3[2],p3[3]


        local cz=.01*(p1z+p2z+p3z)/3
        local cx=.01*(p1x+p2x+p3x)/3
        local cy=.01*(p1y+p2y+p3y)/3
        local z_paint= -cx*cx-cy*cy-cz*cz




        if(object.background==true) z_paint-=1000
        face[6]=z_paint


        if((p1z>z_max or p2z>z_max or p3z>z_max))then
            if(p1z< z_clip and p2z< z_clip and p3z< z_clip)then
            --simple option -- no clipping required

                    local s1x,s1y = p1[4],p1[5]
                    local s2x,s2y = p2[4],p2[5]
                    local s3x,s3y = p3[4],p3[5]


                    if( max(s3x,max(s1x,s2x))>0 and min(s3x,min(s1x,s2x))<128)  then
                        --only use backface culling on simple option without clipping
                        --check if triangles are backwards by cross of two vectors
                        if(( (s1x-s2x)*(s3y-s2y)-(s1y-s2y)*(s3x-s2x)) < 0)then

                            if(object.color_mode==k_colorize_dynamic)then
                                --nx,ny,nz = vector_cross_3d(p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z)
                                --save a bit on dynamic rendering by moving this funciton inline
                                p2x-=p1x p2y-=p1y p2z-=p1z
                                p3x-=p1x p3y-=p1y p3z-=p1z
                                local nx = p2y*p3z-p2z*p3y
                                local ny = p2z*p3x-p2x*p3z
                                local nz = p2x*p3y-p2y*p3x

                                --nx,ny,nz = normalize(nx,ny,nz)
                                --save a bit by moving this function inline
                                nx=shl(nx,2) ny=shl(ny,2) nz=shl(nz,2)
                                local inv_dist=1/sqrt(nx*nx+ny*ny+nz*nz)
                                nx*=inv_dist ny*=inv_dist nz*=inv_dist


                                --b = vector_dot_3d(nx,ny,nz,t_light_x,t_light_y,t_light_z)
                                --save a bit by moving this function inline
                                face[4],face[5]=color_shade(object.color, mid( nx*t_light_x+ny*t_light_y+nz*t_light_z,0,1)*(1-k_ambient)+k_ambient )
                            end


                            --new_triangle(s1x,s1y,s2x,s2y,s3x,s3y,z_paint,face[k_color1],face[k_color2])
                            --faster to move new triangle function inline
                            add(triangle_list,{p1x=s1x,
                                                p1y=s1y,
                                                p2x=s2x,
                                                p2y=s2y,
                                                p3x=s3x,
                                                p3y=s3y,
                                                tz=z_paint,
                                                c1=face[k_color1],
                                                c2=face[k_color2]})


                        end
                    end

            --not optimizing clipping functions for now
            --these still have errors for large triangles
            elseif(p1z< z_clip or p2z< z_clip or p3z< z_clip)then

            --either going to have 3 or 4 points
                p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z = three_point_sort(p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z)
                if(p1z<z_clip and p2z<z_clip)then



                    local n2x,n2y,n2z = z_clip_line(p2x,p2y,p2z,p3x,p3y,p3z,z_clip)
                    local n3x,n3y,n3z = z_clip_line(p3x,p3y,p3z,p1x,p1y,p1z,z_clip)



                    local s1x,s1y = project_point(p1x,p1y,p1z)
                    local s2x,s2y = project_point(p2x,p2y,p2z)
                    local s3x,s3y = project_point(n2x,n2y,n2z)
                    local s4x,s4y = project_point(n3x,n3y,n3z)


                    if( max(s4x,max(s1x,s2x))>0 and min(s4x,min(s1x,s2x))<128)  then
                        new_triangle(s1x,s1y,s2x,s2y,s4x,s4y,z_paint,face[k_color1],face[k_color2])
                    end
                    if( max(s4x,max(s3x,s2x))>0 and min(s4x,min(s3x,s2x))<128)  then
                        new_triangle(s2x,s2y,s4x,s4y,s3x,s3y,z_paint,face[k_color1],face[k_color2])
                    end
                else


                    local n1x,n1y,n1z = z_clip_line(p1x,p1y,p1z,p2x,p2y,p2z,z_clip)
                    local n2x,n2y,n2z = z_clip_line(p1x,p1y,p1z,p3x,p3y,p3z,z_clip)



                    local s1x,s1y = project_point(p1x,p1y,p1z)
                    local s2x,s2y = project_point(n1x,n1y,n1z)
                    local s3x,s3y = project_point(n2x,n2y,n2z)

                    --solid_trifill(s1x,s1y,s2x,s2y,s3x,s3y,face[k_color1])
                    if( max(s3x,max(s1x,s2x))>0 and min(s3x,min(s1x,s2x))<128)  then
                        new_triangle(s1x,s1y,s2x,s2y,s3x,s3y,z_paint,face[k_color1],face[k_color2])
                    end
                end

                --print("p1",p1x+64,p1z+64,14)
                --print("p2",p2x+64,p2z+64,14)
                --print("p3",p3x+64,p3z+64,14)



            end
        end

    end


end

function three_point_sort(p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z)
    if(p1z>p2z) p1z,p2z = p2z,p1z p1x,p2x = p2x,p1x p1y,p2y = p2y,p1y
    if(p1z>p3z) p1z,p3z = p3z,p1z p1x,p3x = p3x,p1x p1y,p3y = p3y,p1y
    if(p2z>p3z) p2z,p3z = p3z,p2z p2x,p3x = p3x,p2x p2y,p3y = p3y,p2y

    return p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z
end

function quicksort(t, start, endi)
   start, endi = start or 1, endi or #t
  --partition w.r.t. first element
  if(endi - start < 1) then return t end
  local pivot = start
  for i = start + 1, endi do
    if t[i].tz <= t[pivot].tz then
      if i == pivot + 1 then
        t[pivot],t[pivot+1] = t[pivot+1],t[pivot]
      else
        t[pivot],t[pivot+1],t[i] = t[i],t[pivot],t[pivot+1]
      end
      pivot = pivot + 1
    end
  end
   t = quicksort(t, start, pivot - 1)
  return quicksort(t, pivot + 1, endi)
end



function z_clip_line(p1x,p1y,p1z,p2x,p2y,p2z,clip)
    if(p1z>p2z)then
        p1x,p2x=p2x,p1x
        p1z,p2z=p2z,p1z
        p1y,p2y=p2y,p1y
    end

    if(clip>p1z and clip<=p2z)then

    --  line(p1x+64,p1z+64,p2x+64,p2z+64,14)
        alpha= abs((p1z-clip)/(p2z-p1z))
        nx=lerp(p1x,p2x,alpha)
        ny=lerp(p1y,p2y,alpha)
        nz=lerp(p1z,p2z,alpha)

    --  circ(nx+64,nz+64,1,12)
        return nx,ny,nz
    else
        return false
    end
end

function project_point(x,y,z)
    return x*k_screen_scale/z+k_x_center,y*k_screen_scale/z+k_x_center
end

function project_radius(r,z)
    return r*k_screen_scale/abs(z)
end



function lerp(a,b,alpha)
  return a*(1.0-alpha)+b*alpha
end

function init_player()
    player=new_object()
    player.min_x=-4.5
    player.min_y=-4.5
    player.min_z=-4.5
    player.max_x=4.5
    player.max_y=4.5
    player.max_z=4.5

    player.x=0
    player.y=8
    player.z=15

    player.vx=0
    player.vy=0
    player.vz=0
end

k_friction=.7
function update_camera()
    cam_x=player.x
    cam_y=player.y
    cam_z=player.z

    cam_ax=player.ax
    cam_ay=player.ay
    cam_az=player.az

    generate_cam_matrix_transform(cam_ax,cam_ay,cam_az)
end

function init_3d()
    init_player()
    init_light()
    object_list={}
    obstacle_list={}
end

function update_3d()
    for object in all(object_list) do
            update_visible(object)
            transform_object(object)
            cam_transform_object(object)
            update_light()
    end
end

function draw_3d()
    triangle_list={}
    quicksort(object_list)

    start_timer()
    for object in all(object_list) do

        if(object.visible and not object.background) then
            render_object(object) --sort_faces(object)
            --if(object.color_mode==k_colorize_dynamic or object.color_mode==k_multi_color_dynamic) color_faces(object,object.color)
        end
    end
    render_time=stop_timer()

    start_timer()
        quicksort(triangle_list)
    sort_time=stop_timer()

    start_timer()
        draw_triangle_list()
    triangle_time=stop_timer()
end


function shade_trifill( x1,y1,x2,y2,x3,y3, color1, color2)

          local x1=band(x1,0xffff)
          local x2=band(x2,0xffff)
          local y1=band(y1,0xffff)
          local y2=band(y2,0xffff)
          local x3=band(x3,0xffff)
          local y3=band(y3,0xffff)

          local nsx,nex
          --sort y1,y2,y3
          if(y1>y2)then
            y1,y2=y2,y1
            x1,x2=x2,x1
          end

          if(y1>y3)then
            y1,y3=y3,y1
            x1,x3=x3,x1
          end

          if(y2>y3)then
            y2,y3=y3,y2
            x2,x3=x3,x2
          end

         if(y1!=y2)then
            local delta_sx=(x3-x1)/(y3-y1)
            local delta_ex=(x2-x1)/(y2-y1)

            if(y1>0)then
                nsx=x1
                nex=x1
                min_y=y1
            else --top edge clip
                nsx=x1-delta_sx*y1
                nex=x1-delta_ex*y1
                min_y=0
            end

            max_y=min(y2,128)

            for y=min_y,max_y-1 do

            --rectfill(nsx,y,nex,y,color1)
            if(band(y,1)==0)then rectfill(nsx,y,nex,y,color1) else rectfill(nsx,y,nex,y,color2) end
            nsx+=delta_sx
            nex+=delta_ex
            end

        else --where top edge is horizontal
            nsx=x1
            nex=x2
        end


        if(y3!=y2)then
            local delta_sx=(x3-x1)/(y3-y1)
            local delta_ex=(x3-x2)/(y3-y2)

            min_y=y2
            max_y=min(y3,128)
            if(y2<0)then
                nex=x2-delta_ex*y2
                nsx=x1-delta_sx*y1
                min_y=0
            end

             for y=min_y,max_y do

                --rectfill(nsx,y,nex,y,color1)
                if(band(y,1)==0)then rectfill(nsx,y,nex,y,color1) else rectfill(nsx,y,nex,y,color2) end
                nex+=delta_ex
                nsx+=delta_sx
             end

        else --where bottom edge is horizontal
            --rectfill(nsx,y3,nex,y3,color1)
            if(band(y,1)==0)then rectfill(nsx,y3,nex,y3,color1) else rectfill(nsx,y3,nex,y3,color2) end
        end

end

function start_timer()
    timer_value=stat(1)
end

function stop_timer()
    return stat(1)-timer_value
end

function camera()
    return player
end

return {
   init_player = init_player,
   update_player = update_player,
   update_camera = update_camera,
   handle_buttons = handle_buttons,
   init_3d = init_3d,
   update_3d = update_3d,
   draw_3d = draw_3d,
   read_vector_string = read_vector_string,
   read_face_string = read_face_string,
   load_object = load_object,
   matrix_inverse = matrix_inverse,
   camera_matrix_transform = camera_matrix_transform,
   rotate_point = rotate_point,
   camera = camera,
   project_point = project_point
}
