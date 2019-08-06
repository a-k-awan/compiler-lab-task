#include <string>
#include <iostream>
#include <cstdlib>
#include <sstream>
using namespace std;

namespace ast{
int t_idx = 0;
string temp(){
    stringstream ss;
    ss<<".t"<<t_idx++;
    return ss.str();

}
class node{
};

class stmt:public node{
    public:
     virtual void gen(){
    }
};
class expr: public node{
    public:
        virtual expr* lvalue(){
            cerr<<"Error: invalid lvalue\n";
            exit(1);
        }
     virtual expr* rvalue(){
            return this;
        } 
  virtual string str(){
            return "Not implemented";
        }
};
class if_stmt: public stmt{
    public:
        expr *left;
         stmt *right;
        string l;

        if_stmt(expr* e, stmt* s):left(e),right(s){
            l = label(); 
        }
           void gen(){
            expr* e=left->rvalue();
            cout<<"ifFalse "<<e->str()<<" goto "<<l<<"\n";
            right->gen();
            cout<<l<<":";
           }
};
class eval: public stmt{
    public:
        expr* left;

        eval(expr* e):left(e){}

        void gen(){
                left->rvalue();
        }
};
class seq: public stmt{
    public:
        stmt* left;
        stmt* right;

        seq(stmt* l,  stmt* r):left(l),right(r) {}

        void gen(){  left->gen();
            if(right)
                right->gen();
        }
};
class op: public expr{
    public:
    enum op_type{OP_PLUS, OP_MINUS, OP_TIMES, OP_DIV};

    op_type type;
    expr *left, *right;
};
class assign:public expr{
    public:
        expr *left, *right;

        assign(expr* l,  expr* r):left(l),right(r) {}

        expr* rvalue(){
              expr* l = left->lvalue();

            expr* r = right->rvalue(); 
              cout<<l->str()<<"="<<r->str()<<"\n";
            return r;

        }
};

class id: public expr{
    public:
    string lexeme;
    id(string name):lexeme(name){}
       expr* lvalue(){
            return this;
        }

        string str(){
            return lexeme;
        }
};
class num:public expr{
    public:
        int value;

        num(int n):value(n) {}
              string str(){
            stringstream t;
            t<<value;
            return t.str();
        }
};
}