abstract class IEntitySerializable{
    IEntitySerializable();
    
    Map toMap();
    void fromMap(Map m);
}